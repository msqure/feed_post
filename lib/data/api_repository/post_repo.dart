import 'dart:io';
import '../../domain/model/post_model.dart';
import '../api_service/feed_service.dart';



class PostRepository {
  final FeedService _service;

  PostRepository(this._service);

  Future<void> createPost(String caption, File imageFile, String userId) =>
      _service.createPost(caption, imageFile, userId);

  Future<void> editPost(String postId, {String? caption, File? imageFile}) =>
      _service.editPost(postId, caption: caption, imageFile: imageFile);

  Future<void> deletePost(String postId) => _service.deletePost(postId);

  Future<void> toggleSwitch(String postId,String userId) => _service.toggleLike(postId,userId);



  Stream<List<PostModel>> getPosts() => _service.getPosts();
}

