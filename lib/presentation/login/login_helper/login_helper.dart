import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth/auth_bloc.dart';



class LoginHelperWidgets {



  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();



  Widget emailField() {
    return TextField(
      controller: emailController,
      decoration: const InputDecoration(labelText: "Email"),
    );
  }

  Widget passwordField() {
    return TextField(
      controller: passController,
      obscureText: true,
      decoration: const InputDecoration(labelText: "Password"),
    );
  }

  Widget loginButton({required BuildContext context}) {
    return ElevatedButton(
      onPressed: () {
        context.read<AuthBloc>().add(
          SignInRequested(emailController.text, passController.text),
        );
      },
      child: const Text("Login"),
    );
  }

  void disposeControllers() {
    emailController.dispose();
    passController.dispose();
  }
}
