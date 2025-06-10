import 'package:flutter/material.dart';
import '../../blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../post/home_screen.dart';
import 'login_helper/login_helper.dart';


class LoginScreen extends StatefulWidget {


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final loginHelperWidgets = LoginHelperWidgets();
  @override
  Widget build(BuildContext context) {
  /*  final helper = LoginHelperWidgets(
      emailController: loginHelperWidgets.emailController,
      passController: loginHelperWidgets.passController,
    );*/
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated)
          {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (state is AuthError)
          {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                loginHelperWidgets.emailField(),
                loginHelperWidgets.passwordField(),
                const SizedBox(height: 20),
                loginHelperWidgets.loginButton(context: context),
              ],
            ),
          );
        },
      ),
    );
  }
}

