import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muslim/src/core/config/hive_service.dart';
import 'package:muslim/src/data/models/user_model.dart';
import 'package:muslim/src/data/repository/user_repoitory.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepoitory userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<UpdateEvent>((event, emit) => update(event, emit));
  }

  Future<void> update(UpdateEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingState());
      await userRepository.updateUser(
          event.uid, {'fullName': event.fullName, "phone": event.phone});
      UserModel user = HiveService.instance.getUserData('user');
      user.fullName = event.fullName;
      user.phone = event.phone;
      await HiveService.instance.setUserData('user', user);
      emit(UpdatedState());
    } catch (e) {
      emit(FailedState(error: e.toString()));
    }
  }
}
