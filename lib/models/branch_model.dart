class Branch {
  final String companyId;
  final String branchId;
  final String? branchCode;
  final String? email;

  final String? location;
  final String? description;
  final String? phoneNumber;
  final String? website;

  // ── BOOL FIELDS ARE NOW NULLABLE ─────────────────────
  final bool? isActive;
  final bool? isOnline;
  final bool? disabled;
  final bool? reusedEmail;
  // ─────────────────────────────────────────────────────

  final DateTime? lastLogin;
  final DateTime createdAt;
  final String? branchType;
  final String? branchName;
  final String? profileImage;
  final String? headerImage;
  final DateTime? disabledAt;
  final DateTime? reEnabledAt;
  final String id;
  final int sequence;
  final DateTime createdAtLocal;
  final DateTime updatedAt;
  final List<String> permissions;
  final String databaseId;
  final String collectionId;

  Branch({
    required this.companyId,
    required this.branchId,
    this.branchCode,
    this.email,
    this.location,
    this.description,
    this.phoneNumber,
    this.website,
    this.isActive,
    this.isOnline,
    this.disabled,
    this.reusedEmail,
    this.lastLogin,
    required this.createdAt,
    this.branchType,
    this.branchName,
    this.profileImage,
    this.headerImage,
    this.disabledAt,
    this.reEnabledAt,
    required this.id,
    required this.sequence,
    required this.createdAtLocal,
    required this.updatedAt,
    required this.permissions,
    required this.databaseId,
    required this.collectionId,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      companyId: json['company_id'] as String,
      branchId: json['branch_id'] as String,
      branchCode: json['branch_code'] as String?,
      email: json['email'] as String?,

      location: json['location'] as String?,
      description: json['description'] as String?,
      phoneNumber: json['phone_number'] as String?,
      website: json['website'] as String?,

      // ── SAFE BOOL PARSING ─────────────────────────────
      isActive: json['is_active'] as bool?,
      isOnline: json['is_online'] as bool?,
      disabled: json['disabled'] as bool?,
      reusedEmail: json['reused_email'] as bool?,

      // ───────────────────────────────────────────────────
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      branchType: json['branch_type'] as String?,
      branchName: json['branch_name'] as String?,
      profileImage: json['profile_image'] as String?,
      headerImage: json['header_image'] as String?,
      disabledAt: json['disabled_at'] != null
          ? DateTime.parse(json['disabled_at'] as String)
          : null,
      reEnabledAt: json['re_enabled_at'] != null
          ? DateTime.parse(json['re_enabled_at'] as String)
          : null,
      id: json[r'$id'] as String,
      sequence: json[r'$sequence'] as int,
      createdAtLocal: DateTime.parse(json[r'$createdAt'] as String),
      updatedAt: DateTime.parse(json[r'$updatedAt'] as String),
      permissions: List<String>.from(
        (json[r'$permissions'] as List).map((e) => e.toString()),
      ),
      databaseId: json[r'$databaseId'] as String,
      collectionId: json[r'$collectionId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
      'branch_id': branchId,
      'branch_code': branchCode,
      'email': email,
      'location': location,
      'description': description,
      'phone_number': phoneNumber,
      'website': website,
      'is_active': isActive,
      'is_online': isOnline,
      'last_login': lastLogin?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'branch_type': branchType,
      'branch_name': branchName,
      'profile_image': profileImage,
      'header_image': headerImage,
      'disabled': disabled,
      'disabled_at': disabledAt?.toIso8601String(),
      're_enabled_at': reEnabledAt?.toIso8601String(),
      'reused_email': reusedEmail,
      r'$id': id,
      r'$sequence': sequence,
      r'$createdAt': createdAtLocal.toIso8601String(),
      r'$updatedAt': updatedAt.toIso8601String(),
      r'$permissions': permissions,
      r'$databaseId': databaseId,
      r'$collectionId': collectionId,
    };
  }
}
