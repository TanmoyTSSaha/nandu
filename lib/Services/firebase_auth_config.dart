import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  Future signInWithGoogle() async {
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

      //Once signed in, return to the UserCredential.
      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (user.user != null) {
        log('${googleUser.email} ${googleUser}');
        await FirebaseAuthConfig().storeData(
          googleUser.displayName.toString(),
          googleUser.email.toString(),
          FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
        );
      }
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
        await FirebaseAuthConfig().storeData(
          facebookName.toString(),
          facebookEmail.toString(),
          FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
        );
      }

      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } catch (e) {
      log(" catch mathod of signInWithFacebook : " + e.toString());
    }
  }

  resetPassword(String email) async {
    bool hasError = false;
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (exception) {
      hasError = true;
      if (exception.code == "user-not-found") {
        Get.snackbar("User not found", "Please enter a valid email address!",
            backgroundColor: Color(0xFF00880D), colorText: Colors.white);
      } else if (exception.code == "invalid-email") {
        Get.snackbar("Invalid Email", "Please enter a valid email address!",
            backgroundColor: Color(0xFF00880D), colorText: Colors.white);
      } else {
        Get.snackbar("Error", "${exception.code}",
            backgroundColor: Color(0xFF00880D), colorText: Colors.white);
      }
    } catch (e) {
      hasError = true;
      Get.snackbar("Error", "$e",
          backgroundColor: Color(0xFF00880D), colorText: Colors.white);
    } finally {
      Get.snackbar("Reset Password",
          "A link has been sent to your email address. \nPlease check the Spam section.",
          backgroundColor: Color(0xFF00880D), colorText: Colors.white);
    }
  }

  Future storeData(
      String username, String emailAddress, String phoneNumber) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'username': username,
        'emailAddress': emailAddress,
        'phoneNumber': phoneNumber,
      });
      Get.offAll(() => Home());
    } catch (e) {
      log(e.toString());
    }
  }
}
