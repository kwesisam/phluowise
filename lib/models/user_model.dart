class UserModel {
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final String? userType;
  final String? uid;
  final String? phoneNumber2;
  final String? location;

  final String? id;
  final int? sequence;
  final String? createdAt;
  final String? updatedAt;
  final List<String>? permissions;
  final String? databaseId;
  final String? collectionId;

  UserModel({
    this.fullName,
    this.phoneNumber,
    this.email,
    this.userType,
    this.uid,
    this.phoneNumber2,
    this.location,
    this.id,
    this.sequence,
    this.createdAt,
    this.updatedAt,
    this.permissions,
    this.databaseId,
    this.collectionId,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['full_name'],
      phoneNumber: map['phone_number'],
      email: map['email'],
      userType: map['user_type'],
      uid: map['uid'],
      phoneNumber2: map['phone_number2'],
      location: map['location'],
      id: map['\$id'],
      sequence: map['\$sequence'],
      createdAt: map['\$createdAt'],
      updatedAt: map['\$updatedAt'],
      permissions: map['\$permissions'] != null
          ? List<String>.from(map['\$permissions'])
          : null,
      databaseId: map['\$databaseId'],
      collectionId: map['\$collectionId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'phone_number': phoneNumber,
      'email': email,
      'user_type': userType,
      'uid': uid,
      'phone_number2': phoneNumber2,
      'location': location,
    };
  }

  /// CopyWith
  UserModel copyWith({
    String? fullName,
    String? phoneNumber,
    String? email,
    String? userType,
    String? uid,
    String? phoneNumber2,
    String? location,
    String? id,
    int? sequence,
    String? createdAt,
    String? updatedAt,
    List<String>? permissions,
    String? databaseId,
    String? collectionId,
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      uid: uid ?? this.uid,
      phoneNumber2: phoneNumber2 ?? this.phoneNumber2,
      location: location ?? this.location,
      id: id ?? this.id,
      sequence: sequence ?? this.sequence,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      permissions: permissions ?? this.permissions,
      databaseId: databaseId ?? this.databaseId,
      collectionId: collectionId ?? this.collectionId,
    );
  }
}
