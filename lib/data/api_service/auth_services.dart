import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final auth = FirebaseAuth.instance;
  Future<User?> signIn(String email, String password) async {
    try {
      final userCred = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCred.user;
    } on FirebaseAuthException catch (e) {
      print("SignIn Error: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      print("Unexpected SignIn Error: $e");
      throw Exception("An unexpected error occurred");
    }
  }

  Future<User?> signUp(String email, String password) async {
    final userCred = await auth.createUserWithEmailAndPassword(email: email, password: password);
    return userCred.user;
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      print("SignOut Error: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      print("Unexpected SignOut Error: $e");
      throw Exception("An unexpected error occurred during sign out");
    }
  }

  Stream<User?> get authStateChanges {
    try {
      return auth.authStateChanges();
    } catch (e) {
      print("AuthStateChanges Error: $e");
      throw Exception("An unexpected error occurred with auth state");
    }
  }
}
