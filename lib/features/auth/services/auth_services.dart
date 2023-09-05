import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/utils/firebase_methods.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseMethods firebaseMethods = FirebaseMethods();

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    Uint8List? file,
  }) async {
    String res = 'Some error occured!';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        UserCredential credentials = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String? photoUrl;
        if (file != null) {
          photoUrl = await firebaseMethods.uploadImage('profilePic', file, false);
        }

        model.User user = model.User(
            username: username,
            email: email,
            uid: credentials.user!.uid,
            bio: bio,
            photoUrl: photoUrl,
            followers: [],
            following: []);
        await _firestore
            .collection('users')
            .doc(credentials.user!.uid)
            .set(user.toJson());
        res = 'success';
      }
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'email-already-in-use':
          res = 'Email already in use';
          break;
        case 'weak-password':
          res = 'Password is too weak';
          break;
        case 'invalid-email':
          res = 'Invalid email';
          break;
        case 'operation-not-allowed':
          res = 'Operation not allowed';
          break;
      }
    }
    return res;
  }

  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured!";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please fill all the fields';
      }
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'invalid-email':
          res = 'Invalid email or password';
          break;
        case 'user-disabled':
          res = 'User disabled';
          break;
        case 'user-not-found':
          res = 'User not found';
          break;
        case 'wrong-password':
          res = 'Invalid email or password';
          break;
      }
    }
    return res;
  }
}
