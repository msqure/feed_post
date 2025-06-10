import 'package:feed_application/blocs/feeds/feed_event.dart';
import 'package:feed_application/blocs/feeds/feed_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/feeds/feed_bloc.dart';
import 'create_and_edit_post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feed')),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) return Center(child: CircularProgressIndicator());
          if (state is PostError) return Center(child: Text(state.message));
          if (state is PostLoaded) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (_, index) {
                final post = state.posts[index];
                return ListTile(
                  leading: Image.network(post.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                  title: Text(post.caption),
                  subtitle: Text(post.createdAt.toDate().toString()),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
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
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                );
              },
            );
          }
          return CircularProgressIndicator(); // default fallback
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Create screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateEditPostScreen(), // isEdit false by default
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
