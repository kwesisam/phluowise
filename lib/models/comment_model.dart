class Comment {
  final String id;         
  final String branchId;      
  final String commentId;
  final String authorId;
  final String content;
  final String authorName;
  final String? avatar;
  final List<String>? productTags;
  final double? rating;
  final DateTime createdAt;  
  final DateTime updatedAt;  

  Comment({
    required this.id,
    required this.branchId,
    required this.commentId,
    required this.authorId,
    required this.content,
    required this.authorName,
    this.avatar,
    this.productTags,
    this.rating,
    required this.createdAt,
    required this.updatedAt,
  });


  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['\$id'] as String,
      branchId: map['branchId'] as String,
      commentId: map['commentId'] as String,
      authorId: map['authorId'] as String,
      content: map['content'] as String,
      authorName: map['authorName'] as String,
      avatar: map['avatar'] as String?,
      productTags: map['productTag'] != null
          ? List<String>.from(map['productTag'])
          : null,
      rating: map['rating'] != null
          ? (map['rating'] as num).toDouble()
          : null,
      createdAt: DateTime.parse(map['\$createdAt']),
      updatedAt: DateTime.parse(map['\$updatedAt']),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'branchId': branchId,
      'commentId': commentId,
      'authorId': authorId,
      'content': content,
      'authorName': authorName,
      'avatar': avatar,
      'productTag': productTags,
      'rating': rating,
    };
  }

  /// -----------------------------
  /// copyWith
  /// -----------------------------
  Comment copyWith({
    String? id,
    String? branchId,
    String? commentId,
    String? authorId,
    String? content,
    String? authorName,
    String? avatar,
    List<String>? productTags,
    double? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Comment(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      commentId: commentId ?? this.commentId,
      authorId: authorId ?? this.authorId,
      content: content ?? this.content,
      authorName: authorName ?? this.authorName,
      avatar: avatar ?? this.avatar,
      productTags: productTags ?? this.productTags,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }


  int get starRating => rating?.round() ?? 0;

  String get avatarUrl =>
      avatar?.isNotEmpty == true ? avatar! : '';

  String get preview =>
      content.length > 100 ? '${content.substring(0, 100)}...' : content;
}
