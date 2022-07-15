import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nandu/screens/home.dart';
import 'package:nandu/screens/signIn.dart';
import 'package:nandu/screens/signUp.dart';
import 'package:nandu/screens/termsConditions.dart';

class SignInOptions extends StatefulWidget {
  const SignInOptions({Key? key}) : super(key: key);

  @override
  State<SignInOptions> createState() => _SignInOptionsState();
}

class _SignInOptionsState extends State<SignInOptions> {
  String facebookEmail = '';
  String facebookNumber = '';
  String facebookName = '';
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double height10 = screenHeight / 78;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: height10 * 3,
                  left: height10 * 2,
                  right: height10 * 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Welcome to ",
                          style: TextStyle(
                              fontSize: height10 * 1.8,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                        SvgPicture.asset(
                          "assets/icons/Logo.svg",
                          height: height10 * 2.5,
                        ),
                      ],
                    ),
                    SizedBox(height: height10 * 0.8),
                    Text(
                      "Guide to farming is here.",
                      style: TextStyle(
                        fontSize: height10 * 1.2,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.0005,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                'assets/images/Illustration.svg',
              ),
              SizedBox(height: height10 * 1.6),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: height10 * 2.0),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 2,
                      text: TextSpan(
                        text: "I agree to Nandur’s ",
                        style: TextStyle(
                          fontSize: height10,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF9E9E9E),
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.005,
                        ),
                        children: [
                          TextSpan(
                            text: "Terms of Services",
                            style: TextStyle(
                              fontSize: height10,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF00880D),
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.005,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => TermsAndConditions());
                              },
                          ),
                          TextSpan(
                            text: " and confirm that I have read Nandur’s ",
                            style: TextStyle(
                              fontSize: height10,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFF9E9E9E),
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.005,
                            ),
                          ),
                          TextSpan(
                            text: "Privacy Policy.",
                            style: TextStyle(
                              fontSize: height10,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF00880D),
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.005,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => TermsAndConditions());
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height10 * 3.2),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: height10 * 2.0,
                              vertical: height10 * 1.2),
                          primary: Colors.white,
                          elevation: 0.0,
                          side: BorderSide(
                            width: height10 * 0.1,
                            color: const Color(0xFFE0E0E0),
                          ),
                          minimumSize: Size(height10 * 33.5, height10 * 4.8)),
                      onPressed: () async {
                        log("Log in with Google TAPPED!");
                        signInWithGoogle();
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({
                          'uid': FirebaseAuth.instance.currentUser!.uid,
                          'username': FirebaseAuth
                              .instance.currentUser!.displayName
                              .toString(),
                          'emailAddress': FirebaseAuth
                              .instance.currentUser!.email
                              .toString(),
                          'phoneNumber': FirebaseAuth
                              .instance.currentUser!.phoneNumber
                              .toString(),
                        });
                        Get.offAll(() => const Home());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset("assets/icons/Google.svg"),
                          const Spacer(),
                          Text(
                            "Continue with Google",
                            style: TextStyle(
                              fontSize: height10 * 1.5,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              color: const Color(0xFF404040),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(height: height10 * 1.2),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: height10 * 2,
                              vertical: height10 * 1.2),
                          primary: const Color(0xFF4B67AD),
                          elevation: 0.0,
                          minimumSize: Size(height10 * 33.5, height10 * 4.8)),
                      onPressed: () async {
                        log("Facebook Login TAPPED!");
                        signInWithFacebook();
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({
                          'uid':
                              FirebaseAuth.instance.currentUser!.uid.toString(),
                          'emailAddress': facebookEmail.toString(),
                          'name': facebookName.toString(),
                          'phoneNumber': null,
                        });
                        Get.offAll(() => const Home());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset("assets/icons/facebook.svg"),
                          const Spacer(),
                          Text(
                            "Continue with Facebook",
                            style: TextStyle(
                              fontSize: height10 * 1.5,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              color: const Color(0xFFFFFFFF),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(height: height10 * 1.2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                width: height10 * 0.1,
                                color: const Color(0xFFE0E0E0),
                              ),
                              primary: const Color(0xFFFFFFFF),
                              elevation: 0.0,
                              minimumSize:
                                  Size(height10 * 15.4, height10 * 4.8)),
                          onPressed: () {
                            Get.to(() => const SignIn());
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: height10 * 1.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF00880D),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: const Color(0xFF00880D),
                              elevation: 0.0,
                              minimumSize:
                                  Size(height10 * 15.4, height10 * 4.8)),
                          onPressed: () {
                            Get.to(() => const SignUp());
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: height10 * 1.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithFacebook() async {
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
    facebookName = userData['public_profile']['name'];

    //Once signed in return the UserCredential.
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
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

      //Once signed in, return to the UserCredential.
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log(e.toString());
    }
  }
}
