part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class LogedInState extends AuthState {}

final class LoadingState extends AuthState {}

final class SignOutState extends AuthState {}

final class ResetPasswordState extends AuthState {}



final class FailedState extends AuthState {
  final String error;
  FailedState({required this.error});
}

final class SignedUpState extends AuthState {}

