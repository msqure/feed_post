import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/api_service/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<AppStarted>((event, emit) async
    {
      final user =  FirebaseAuth.instance.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<SignInRequested>((event, emit) async
    {
      emit(AuthLoading());
      try {
        final user = await _authService.signIn(event.email, event.password);
        emit(AuthAuthenticated(user!));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignOutRequested>((event, emit) async {
      await _authService.signOut();
      emit(AuthUnauthenticated());
    });
  }
}

