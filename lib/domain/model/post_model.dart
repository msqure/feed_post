class PostModel {
  final String id;
  final String userId;
  final String caption;
  final String imageUrl;
  final String createdAt;
  final int? likesCount;
  final int? commentsCount;
  final List<String>? likedBy;
  final String? userEmail; // Optional for display purposes

  PostModel({
    required this.id,
    required this.userId,
    required this.caption,
    required this.imageUrl,
    required this.createdAt,
    this.likesCount,
    this.commentsCount,
    this.userEmail,
    this.likedBy,
  });

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'caption': caption,
        'imageUrl': imageUrl,
        'createdAt': createdAt,
        'likesCount': likesCount,
        'commentsCount': commentsCount,
        if (userEmail != null) 'userEmail': userEmail,
      };

  factory PostModel.fromMap(String id, Map<String, dynamic> map) {
    return PostModel(
      id: id,
      userId: map['userId'] ?? '',
      caption: map['caption'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: map['createdAt'].toString() ,
      likesCount: map['likesCount'] ?? 0,
      commentsCount: map['commentsCount'] ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
      userEmail: map['userEmail'], // Optional
    );
  }
}
