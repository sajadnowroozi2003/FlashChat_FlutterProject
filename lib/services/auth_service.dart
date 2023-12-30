import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future createUser({required String email, required String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future signInUser({
    required String email,
    required String passwrod,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: passwrod,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
