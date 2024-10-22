import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:muslim/src/data/models/user_model.dart';
import 'package:muslim/src/data/repository/auth_repository.dart';

import '../../../core/config/hive_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) => signUp(event, emit));
    on<LogInWithCredentialsEvent>(
        (event, emit) => logInWithCredentials(event, emit));
    on<ResetPasswordEvent>((event, emit) => resetPassword(event, emit));
    on<SignOutEvent>((event, emit) => signOut(event, emit));
  }

  Future<void> logInWithCredentials(
      LogInWithCredentialsEvent event, Emitter<AuthState> emit) async {
    try {
      emit(LoadingState());
      UserModel user = await authRepository.logIn(
        event.email,
        event.password,
      );
      await HiveService.instance.setUserData('user', user);
      emit(LogedInState());
    } catch (e) {
      emit(FailedState(error: e.toString()));
    }
  }

  Future<void> resetPassword(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    try {
      emit(LoadingState());
      await authRepository.resetPassword(event.email);
      emit(ResetPasswordState());
    } catch (e) {
      emit(FailedState(error: e.toString()));
    }
  }

  Future<void> signOut(AuthEvent event, Emitter<AuthState> emit) async {
    try {
      emit(LoadingState());
      await authRepository.signOut();
      await HiveService.instance.removeUserData('user');
      emit(SignOutState());
    } catch (e) {
      emit(FailedState(error: e.toString()));
    }
  }

  Future<void> signUp(SignUpEvent event, Emitter<AuthState> emit) async {
    try {
      emit(LoadingState());
      UserModel user = await authRepository.signUp(
        event.email,
        event.password,
        event.data,
      );
      await HiveService.instance.setUserData('user', user);
      emit(SignedUpState());
    } catch (e) {
      emit(FailedState(error: e.toString()));
    }
  }
}
