import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:phluowise/models/product_model.dart';
import 'package:phluowise/models/user_model.dart';
import 'package:phluowise/models/workdingdays_model.dart';
import 'package:phluowise/utils/response.dart';
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
  final String workingDaysId = 'working_days';
  final String commentCollectionsId = 'comments';

  // Hold branches in memory
  List<Map<String, dynamic>> _branches = [];
  List<Map<String, dynamic>> get branches => _branches;
  List<Map<String, dynamic>> _branchComments = [];
  List<Map<String, dynamic>> get branchComments => _branchComments;

  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;

  // For stream (optional, but useful)
  final _branchesController =
      BehaviorSubject<List<Map<String, dynamic>>>.seeded([]);

  User? _user;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  StreamSubscription<RealtimeMessage>? _realtimeBranchesSubscription;
  StreamSubscription<RealtimeMessage>? _realtimeBranchCommentSubscription;

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
    _setupRealtimeLoadBranches();
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
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      try {
        await account.deleteSessions();
      } catch (_) {}

      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      _user = await account.get();
      await fetchUserData(userId: _user!.$id);
      await _loadInitialBranches();

      notifyListeners();

      return response(
        status: true,
        message: 'Login successful',
        data: userData,
      );
    } on AppwriteException catch (e) {
      return response(
        status: false,
        message: e.message ?? 'Login failed',
        data: null,
      );
    } catch (e) {
      return response(
        status: false,
        message: 'Something went wrong. Please try again.',
        data: null,
      );
    }
  }

  /// Sign up
  Future<Map<String, dynamic>> createAccount({
    required String fullname,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      // 1. Create auth account
      await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: fullname,
      );

      // 2. Auto login
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      _user = await account.get();

      // 3. Insert user profile
      await databases.createDocument(
        databaseId: databaseId,
        collectionId: customerTb,
        documentId: ID.unique(),
        data: {
          'uid': _user!.$id,
          'full_name': fullname,
          'phone_number': phone,
          'email': email,
          'user_type': 'individual',
        },
      );

      await fetchUserData(userId: _user!.$id);
      await _loadInitialBranches();

      notifyListeners();

      return response(
        status: true,
        message: 'Account created successfully',
        data: userData,
      );
    } on AppwriteException catch (e) {
      return response(
        status: false,
        message: e.message ?? 'Account creation failed',
        data: null,
      );
    } catch (e) {
      return response(
        status: false,
        message: 'Unexpected error occurred',
        data: null,
      );
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } catch (_) {}
    _user = null;
    userData = null;

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

      print(userId);
      print(response);
      print(response.documents.first.data);

      if (response.documents.isNotEmpty) {
        userData = UserModel.fromMap(response.documents.first.data);
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      notifyListeners();
    }
  }

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
  void _setupRealtimeLoadBranches() {
    final channel =
        'databases.$databaseId.collections.$branchesCollectionId.documents';

    _realtimeBranchesSubscription = realtime.subscribe([channel]).stream.listen(
      (message) {
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
        notifyListeners();
      },
    );
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

  // MARK: Working days
  Future<List<WorkingDay>> loadBranchWorkingDays({
    required String branchId,
  }) async {
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: workingDaysId,
        queries: [Query.equal('branch_id', branchId)],
      );

      final workingDays = response.documents
          .map((doc) => WorkingDay.fromMap(doc.data))
          .toList();

      print("Loaded ${workingDays.length} working");

      return workingDays;
    } catch (e) {
      print("Error loading working days: $e");
      return [];
    }
  }

  // MARKS: Comments

  Future<Map<String, dynamic>> createComment({
    required String commentId,
    required String authorId,
    required String content,
    required String authorName,
    required List<String> productTag,
    required double rating,
    required String branchId,
  }) async {
    try {
      await databases.createDocument(
        databaseId: databaseId,
        collectionId: commentCollectionsId,
        documentId: ID.unique(),
        data: {
          'commentId': commentId,
          'authorId': authorId,
          'content': content,
          'authorName': authorName,
          'productTag': productTag,
          'rating': rating,
          'branchId': branchId,
        },
      );

      return response(
        status: true,
        message: 'Comment created successfully',
        data: userData,
      );
    } on AppwriteException catch (e) {
      return response(
        status: false,
        message: e.message ?? 'Comment creation failed',
        data: null,
      );
    } catch (e) {
      return response(
        status: false,
        message: 'Unexpected error occurred',
        data: null,
      );
    }
  }

  Future<void> loadInitialBranchesComment({required String branchId}) async {
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: commentCollectionsId,
        queries: [
          Query.equal('branchId', branchId),
          Query.orderDesc('\$createdAt'),
        ],
      );

      _branchComments = response.documents.map((doc) => doc.data).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Error loading branch comments: $e");
    }
  }

  void setupRealtimeLoadBranchComment({required String branchId}) {
    final channel =
        'databases.$databaseId.collections.$commentCollectionsId.documents';

    _realtimeBranchCommentSubscription?.cancel();

    _realtimeBranchCommentSubscription = realtime
        .subscribe([channel])
        .stream
        .listen((message) {
          if (message.payload.isEmpty) return;

          final payload = Map<String, dynamic>.from(message.payload);
          if (payload['branchId'] != branchId) return;

          final event = message.events.first;
          final updated = List<Map<String, dynamic>>.from(_branchComments);

          if (event.contains('create')) {
            final exists = updated.any((c) => c['\$id'] == payload['\$id']);
            if (!exists) updated.insert(0, payload);
          } else if (event.contains('update')) {
            final index = updated.indexWhere(
              (c) => c['\$id'] == payload['\$id'],
            );
            if (index != -1) updated[index] = payload;
          } else if (event.contains('delete')) {
            updated.removeWhere((c) => c['\$id'] == payload['\$id']);
          }

          _branchComments = updated;
          notifyListeners();
        });
  }

  @override
  void dispose() {
    _realtimeBranchesSubscription?.cancel();
    _realtimeBranchCommentSubscription?.cancel();
    _branchesController.close();
    super.dispose();
  }
}
