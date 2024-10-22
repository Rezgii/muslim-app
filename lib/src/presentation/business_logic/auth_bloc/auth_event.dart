part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final Map<String, dynamic> data;

  SignUpEvent(this.email, this.password, this.data);

  @override
  List<Object?> get props => [email, password, data];
}

class LogInWithCredentialsEvent extends AuthEvent {
  final String email;
  final String password;

  LogInWithCredentialsEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  ResetPasswordEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class SignOutEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}
