import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nandu/auth_checker.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String uid = "";
  @override
  void initState() {
    // uid = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Home"),
            // Text("User ID : $uid"),
            ElevatedButton(
              onPressed: () async {
                log(FirebaseAuth.instance.currentUser!.uid.toString());
                await _auth.signOut();
                // log(FirebaseAuth.instance.currentUser.uid.toString());
              },
              child: const Text("Sign Out"),
            ),
            ElevatedButton(
              onPressed: () async {
                await GoogleSignIn().signOut();
              },
              child: const Text("Google Sign Out"),
            ),
            ElevatedButton(
              onPressed: () async {
                await FacebookAuth.instance.logOut();
              },
              child: const Text("Facebook Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
