import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final firebase = FirebaseAuth.instance;

  Future<void> loginUser(String email, String password) async {
    try {
      await firebase.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> registerUser(String email, String password, String name) async {
    try {
      final user = await firebase.createUserWithEmailAndPassword(
          email: email, password: password);
      await FirebaseFirestore.instance
          .collection("user")
          .doc(user.user!.uid)
          .set({
        "email": email,
        "fullname": name,
      });
    } catch (e) {
      rethrow;
    }
  }
}
