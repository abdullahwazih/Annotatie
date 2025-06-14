import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signUp({
    required String email,
    required String password,
    required String username,
    required String role,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email.trim(),
        'username': username.trim(),
        'role': role.trim(),
      });
      return null;
    } catch (e) {
      if (e is FirebaseAuthException) {
        return e.message;
      } else {
        return 'An unexpected error occurred';
      }
    }
  }

  Future<String?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      return userDoc['role'] as String?;
    } catch (e) {
      if (e is FirebaseAuthException) {
        return e.message;
      } else {
        return 'An unexpected error occurred';
      }
    }
  }
}
