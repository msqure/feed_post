import 'dart:async';

import 'package:feed_application/blocs/feeds/feed_state.dart';
import 'package:feed_application/data/api_repository/post_repo.dart';
import '../../domain/model/post_model.dart';
import 'feed_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repository;

  StreamSubscription? _postSubscription;

  PostBloc(this.repository) : super(PostInitial()) {
    on<LoadPosts>((event, emit) {
      emit(PostLoading());
      _postSubscription?.cancel();
      _postSubscription = repository.getPosts().listen((posts) {
        add(_PostsUpdated(posts));
      });
    });

    on<_PostsUpdated>((event, emit) {
      emit(PostLoaded(event.posts));
    });

    on<CreatePost>((event, emit) async {
      await repository.createPost(event.caption, event.imageFile, event.userId);
    });

    on<EditPost>((event, emit) async {
      await repository.editPost(event.postId, caption: event.caption, imageFile: event.imageFile);
    });

    on<DeletePost>((event, emit) async {
      await repository.deletePost(event.postId);
    });

    on<ToggleLikePost>((event, emit) async {
      try {
        await repository.toggleSwitch(event.postId, event.userId);
      } catch (e) {
        emit(PostError("Failed to like/unlike post $e"));
      }
    });
  }

  @override
  Future<void> close() {
    _postSubscription?.cancel();
    return super.close();
  }
}

class _PostsUpdated extends PostEvent {
  final List<PostModel> posts;
  _PostsUpdated(this.posts);
}

