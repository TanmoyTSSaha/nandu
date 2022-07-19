import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/home.dart';

class FirebaseAuthConfig {
  signUpWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        return "The password provided is too weak.";
      } else if (e.code == "email-already-in-use") {
        return "The account already exists for that email.";
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        Get.to(() => const Home());
      } else {
        Get.snackbar("Error", "Error");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return "No user found for that email.";
      } else if (e.code == "wrong-password") {
        return "Wrong password provided for that user.";
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  signInWithGoogle() async {
    try {
      log("signInWithGoogle Initialized");
      //Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      //Obtain the auth details from the request.
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      //Create a new credential.
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      if (credential.accessToken != null) {
        Get.offAll(() => const Home());
      }
      //Once signed in, return to the UserCredential.
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log(e.toString());
    }
  }

  signInWithFacebook(String facebookEmail, String facebookName) async {
    try {
      // This trigger the sign in flow.
      final LoginResult loginResult =
          await FacebookAuth.instance.login(permissions: [
        'email',
        'public_profile',
      ]);

      // To create a credential from the access token.
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      final userData = await FacebookAuth.instance.getUserData();
      log(userData.toString());

      facebookEmail = userData['email'];
      facebookName = userData['name'];

      if (userData != null) {
        Get.offAll(() => const Home());
      }

      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } catch (e) {
      log(" catch mathod of signInWithFacebook : " + e.toString());
    }
  }

  storeData(String username, String emailAddress, String phoneNumber) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'username': username,
      'emailAddress': emailAddress,
      'phoneNumber': phoneNumber,
    });
  }
}
