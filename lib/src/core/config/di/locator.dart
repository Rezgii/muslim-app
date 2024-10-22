import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:muslim/src/data/apis/auth_api.dart';
import 'package:muslim/src/data/repository/user_repoitory.dart';
import 'package:muslim/src/presentation/business_logic/auth_bloc/auth_bloc.dart';
import 'package:muslim/src/presentation/business_logic/locale_cubit/locale_cubit.dart';
import 'package:muslim/src/presentation/business_logic/user_bloc/user_bloc.dart';

import '../../../data/apis/user_api.dart';
import '../../../data/repository/auth_repository.dart';
import '../../../presentation/business_logic/internet_cubit/internet_cubit.dart';

final locator = GetIt.instance;

void initializeDependencies() {
  // Use the `registerLazySingleton` method to register dependencies lazily.
  // This method will create the instance only when it is needed.
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  locator.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  //********************************** database **************************** */
  locator.registerLazySingleton<UserApi>(
    () => UserApi(locator<FirebaseFirestore>()),
  );

  locator.registerLazySingleton<AuthApi>(
    () => AuthApi(locator<FirebaseAuth>(), locator<FirebaseFirestore>()),
  );

  //********************************** repositories **************************** */

  locator.registerLazySingleton<UserRepoitory>(
    () => UserRepoitory(locator<UserApi>()),
  );

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepository(locator<AuthApi>(), locator<UserApi>()),
  );

  //********************************** blocs **************************** */

  locator.registerLazySingleton<AuthBloc>(
      () => AuthBloc(locator<AuthRepository>()));

  locator.registerLazySingleton<InternetCubit>(() => InternetCubit());

  locator.registerLazySingleton<LocaleCubit>(() => LocaleCubit());

  locator.registerLazySingleton<UserBloc>(
      () => UserBloc(locator<UserRepoitory>()));
}
