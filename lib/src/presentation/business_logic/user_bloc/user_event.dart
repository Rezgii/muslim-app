part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class UpdateEvent extends UserEvent {
  final String fullName;
  final String phone;
  final String uid;

  const UpdateEvent(this.fullName, this.phone, this.uid);

  @override
  List<Object?> get props => [fullName, phone];
}
