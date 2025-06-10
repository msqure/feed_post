part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AppStarted extends AuthEvent {

  @override
  List<Object?> get props => throw UnimplementedError();
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested(this.email, this.password);

  @override
  List<Object?> get props => [email,password];
}
class SignOutRequested extends AuthEvent
{

  @override
  List<Object?> get props => throw UnimplementedError();
}