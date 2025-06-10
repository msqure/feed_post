import 'dart:io';
import '../data/feed_service.dart';
import '../model/post_model.dart';


class PostRepository {
  final FeedService _service;

  PostRepository(this._service);

  Future<void> createPost(String caption, File imageFile, String userId) =>
      _service.createPost(caption, imageFile, userId);

  Future<void> editPost(String postId, {String? caption, File? imageFile}) =>
      _service.editPost(postId, caption: caption, imageFile: imageFile);

  Future<void> deletePost(String postId) => _service.deletePost(postId);

  Stream<List<PostModel>> getPosts() => _service.getPosts();
}

