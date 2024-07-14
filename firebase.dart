import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nijaat_app/utils.dart';

import 'model.dart';

class FirebaseServices {
  static Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message);
    }
  }

  static Future<void> uploadUserTofireStore(UserProfile userInfo) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userInfo.uid)
          .set(userInfo.mapedInfo());
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  static Future<void> updateUserTofireStore(UserProfile userInfo) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userInfo.uid)
          .update(userInfo.mapedInfo());
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  static Future<void> signup(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message);
    }
  }

  static Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message);
    }
  }

  static Future<String> uploadImage(String path, Uint8List file) async {
    Reference ref = FirebaseStorage.instance.ref().child(path);
    try {
      TaskSnapshot uploadTask = await ref.putData(file);
      String downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      showSnackBar(e.message);
      return e.message!;
    }
  }
}