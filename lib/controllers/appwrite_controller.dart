import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:phluowise/models/product_model.dart';
import 'package:phluowise/models/user_model.dart';
import 'package:rxdart/rxdart.dart'; // Add this

class AppwriteAuthProvider with ChangeNotifier {
  late final Client client;
  late final Account account;
  late final Databases databases;
  late final Storage storage;
  late final Realtime realtime;

  UserModel? userData;

  final String databaseId = '68b1b7590035346a3be9';
  final String storageId = '68b1c57b001542be7fbe';
  final String customerTb = 'customer_tb';
  final String branchesCollectionId = 'branches';
  final String productCollectionId = 'product';

  // Hold branches in memory
  List<Map<String, dynamic>> _branches = [];
  List<Map<String, dynamic>> get branches => _branches;
  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;

  // For stream (optional, but useful)
  final _branchesController =
      BehaviorSubject<List<Map<String, dynamic>>>.seeded([]);

  User? _user;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  StreamSubscription<RealtimeMessage>? _realtimeSubscription;

  AppwriteAuthProvider() {
    client = Client()
        .setEndpoint("https://nyc.cloud.appwrite.io/v1")
        .setProject("68b17582003582da69c8");

    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
    realtime = Realtime(client);

    _loadUser();
    _loadInitialBranches();
    _setupRealtime();
  }

  Future<void> loadUser() async {
    _isInitializing = true;
    notifyListeners();

    await _loadUser();

    _isInitializing = false;
    notifyListeners();
  }

  /// Load current user
  Future<void> _loadUser() async {
    try {
      _user = await account.get();
      await fetchUserData(userId: _user!.$id);
    } catch (e) {
      _user = null;
    }
    notifyListeners();
  }

  /// Login
  Future<void> login({required String email, required String password}) async {
    await account.createEmailPasswordSession(email: email, password: password);
    _user = await account.get();
    await fetchUserData(userId: _user!.$id);

    await _loadInitialBranches();

    notifyListeners();
  }

  /// Logout
  Future<void> logout() async {
    await account.deleteSession(sessionId: 'current');
    _user = null;
    notifyListeners();
  }

  /// Fetch user profile from customer_tb
  Future<void> fetchUserData({required String userId}) async {
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: customerTb,
        queries: [Query.equal('uid', userId)],
      );

      if (response.documents.isNotEmpty) {
        userData = UserModel.fromMap(response.documents.first.data);
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      notifyListeners();
    }
  }

  // Load initial branches
  Future<void> _loadInitialBranches() async {
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: branchesCollectionId,
      );

      _branches = response.documents.map((doc) => doc.data).toList();
      _branchesController.add(_branches);
      notifyListeners();
    } catch (e) {
      print("Error loading branches: $e");
      _branchesController.addError(e);
    }
  }

  // Setup Realtime listener
  void _setupRealtime() {
    final channel =
        'databases.$databaseId.collections.$branchesCollectionId.documents';

    _realtimeSubscription = realtime.subscribe([channel]).stream.listen((
      message,
    ) {
      final payload = message.payload;
      if (payload.isEmpty) return;

      final event = message.events.first;
      final List<Map<String, dynamic>> updated = List.from(_branches);

      if (event.contains('create')) {
        updated.add(payload);
      } else if (event.contains('update')) {
        final index = updated.indexWhere((b) => b['\$id'] == payload['\$id']);
        if (index != -1) {
          updated[index] = payload;
        }
      } else if (event.contains('delete')) {
        updated.removeWhere((b) => b['\$id'] == payload['\$id']);
      }

      _branches = updated;
      _branchesController.add(_branches);
      notifyListeners(); // This rebuilds UI
    });
  }

  // Optional: expose stream (for StreamBuilder if needed)
  Stream<List<Map<String, dynamic>>> branchesStream() =>
      _branchesController.stream;

  // MARK: Products
  Future<List<Product>> loadBranchProducts({required String branchId}) async {
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: productCollectionId,
        queries: [Query.equal('branch_id', branchId)],
      );

      final products = response.documents
          .map((doc) => Product.fromMap(doc.data))
          .toList();

      print("Loaded ${products.length} products");

      return products;
    } catch (e) {
      print("Error loading products: $e");
      return [];
    }
  }

  @override
  void dispose() {
    _realtimeSubscription?.cancel();
    _branchesController.close();
    super.dispose();
  }
}
