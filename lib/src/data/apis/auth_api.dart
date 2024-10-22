import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthApi {
  AuthApi(this.auth, this.firestore);
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseException {
      rethrow;
    }
  }

  Future<UserCredential> signUp(String email, String password) async {
    try {
      return await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseException {
      rethrow;
    }
  }
}
