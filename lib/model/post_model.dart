
class PostModel {
  final String id;
  final String userId;
  final String caption;
  final String imageUrl;
  final dynamic createdAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.caption,
    required this.imageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'caption': caption,
    'imageUrl': imageUrl,
    'createdAt': createdAt,
  };

  factory PostModel.fromMap(String id, Map<String, dynamic> map) {
    return PostModel(
      id: id,
      userId: map['userId'],
      caption: map['caption'],
      imageUrl: map['imageUrl'],
      createdAt: map['createdAt'],
    );
  }
}
