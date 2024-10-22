import 'package:firebase_auth/firebase_auth.dart';
import 'package:muslim/src/data/apis/auth_api.dart';
import 'package:muslim/src/data/apis/user_api.dart';
import 'package:muslim/src/data/models/user_model.dart';

class AuthRepository {
  final AuthApi authApi;
  final UserApi userApi;

  AuthRepository(this.authApi, this.userApi);

  Future<UserModel> logIn(String email, String password) async {
    try {
      final UserCredential userCredential =
          await authApi.signIn(email, password);
      final data = await userApi.getUserFromFirestore(userCredential.user!.uid);
      return UserModel.fromMap(data);
    } on Exception {
      rethrow;
    }
  }

  Future<UserModel> signUp(
      String email, String password, Map<String, dynamic> userData) async {
    try {
      final userCredential = await authApi.signUp(email, password);
      userData['uid'] = userCredential.user!.uid;
      await userApi.addUserToFirestore(userData);
      return UserModel.fromMap(userData);
    } on Exception {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await authApi.resetPassword(email);
    } on Exception {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await authApi.signOut();
    } on Exception {
      rethrow;
    }
  }
}
