import 'dart:io';
abstract class PostEvent {}

class LoadPosts extends PostEvent {}

class CreatePost extends PostEvent {
  final String caption;
  final File imageFile;
  final String userId;

  CreatePost(this.caption, this.imageFile, this.userId);
}

class EditPost extends PostEvent {
  final String postId;
  final String? caption;
  final File? imageFile;

  EditPost(this.postId, {this.caption, this.imageFile});
}

class DeletePost extends PostEvent {
  final String postId;

  DeletePost(this.postId);
}
