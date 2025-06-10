import 'package:feed_application/blocs/feeds/feed_event.dart';
import 'package:feed_application/blocs/feeds/feed_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/feeds/feed_bloc.dart';
import '../../data/api_service/auth_services.dart';
import '../login/login_screen.dart';
import 'create_and_edit_post.dart';
import 'home_helper/home_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeScreen = HomeHelper();


  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context)

  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await authService.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) =>  LoginScreen()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: $e')),
                );
              }
            },
          )
        ],
      ),

      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PostError) return Center(child: Text(state.message));
          if (state is PostLoaded) {

            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                final user = authService.auth.currentUser;
                final isLiked = post.likedBy?.contains(user?.uid);
                return Stack(
                  children: [

                    Positioned.fill(
                      child: Image.network(
                        post.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),


                    Positioned(
                      left: 16,
                      bottom: 80,
                      right: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.userEmail ?? 'Unknown User',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            post.caption,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          /*Text(
                            homeScreen.timeAgo(post.createdAt),
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),*/
                        ],
                      ),
                    ),

                    // Right side: Like, Comment, etc.
                    Positioned(
                      bottom: 80,
                      right: 16,
                      child: Column(
                        children: [
                          PopupMenuButton(
                            iconColor: Colors.white,
                            color: Colors.white
                           , onSelected: (value) {
                              if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CreateEditPostScreen(
                                      isEdit: true,
                                      existingPost: post,
                                    ),
                                  ),
                                );
                              } else if (value == 'delete') {
                                context.read<PostBloc>().add(DeletePost(post.id));
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: 'edit', child: Text('Edit')),
                              const  PopupMenuItem(value: 'delete', child: Text('Delete')),
                            ],
                          ),

                          IconButton(
                            icon:  Icon(Icons.favorite_border,
                              color: (isLiked?? false) ? Colors.red : Colors.white,),
                            onPressed: () {
                              if (user != null) {
                                context.read<PostBloc>().add(ToggleLikePost(postId: post.id, userId: user.uid));
                                context.read<PostBloc>().add(LoadPosts());
                              }
                            },
                          ),
                          Text('${post.likesCount ?? 0}',
                              style: const TextStyle(color: Colors.white)),
                          const SizedBox(height: 16),
                          IconButton(
                            icon:
                                const Icon(Icons.comment, color: Colors.white),
                            onPressed: () {
                              // Navigate to comment screen
                            },
                          ),
                          Text('${post.commentsCount}',
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
          return const CircularProgressIndicator(); // default fallback
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Create screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const CreateEditPostScreen(), // isEdit false by default
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
