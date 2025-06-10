import 'package:feed_application/blocs/feeds/feed_bloc.dart';
import 'package:feed_application/presentation/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/feeds/feed_event.dart';
import 'data/auth_services.dart';
import 'data/feed_service.dart';
import 'domain/post_repo.dart';
import 'firebase_options.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}
/**/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(AuthService())..add(AppStarted())),
        BlocProvider<PostBloc>(
          create: (context) => PostBloc(PostRepository(FeedService()))..add(LoadPosts()),
        ),
      ],
      child: MaterialApp(
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
