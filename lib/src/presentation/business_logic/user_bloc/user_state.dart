part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

final class UpdatedState extends UserState {}

final class LoadingState extends UserState {}

final class FailedState extends UserState {
  final String error;
  const FailedState({required this.error});
}
