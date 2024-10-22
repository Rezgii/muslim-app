import 'package:cloud_firestore/cloud_firestore.dart';

class UserApi {
  UserApi(this.firestore);
  final FirebaseFirestore  firestore;

  Future<Map<String, dynamic>> getUserFromFirestore(String userID) async {
    try {
      final data = await firestore.collection('users').doc(userID).get();
      if(!data.exists) {
        throw FirebaseException(plugin:'user-not-fond');
      }
      return data.data()!;
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> addUserToFirestore(Map<String, dynamic> data) async {
    try {
      await firestore.collection('users').doc(data['uid']).set(data);
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> updateUserToFirestore(
      String userID, Map<String, dynamic> data) async {
    try {
      await firestore.collection('users').doc(userID).update(data);
    } on FirebaseException {
      rethrow;
    }
  }
}
