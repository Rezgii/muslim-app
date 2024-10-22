import 'package:muslim/src/data/models/user_model.dart';

import '../apis/user_api.dart';

class UserRepoitory {
  final UserApi userApi;

  UserRepoitory(this.userApi);

  Future<UserModel> getUser(String userID) async {
    final data = await userApi.getUserFromFirestore(userID);
    return UserModel.fromMap(data);
  }

  Future<void> addUser(Map<String, dynamic> data) async {
    return await userApi.addUserToFirestore(data);
  }

  Future<void> updateUser(String userID, Map<String, dynamic> data) async {
    return await userApi.updateUserToFirestore(userID, data);
  }
}
