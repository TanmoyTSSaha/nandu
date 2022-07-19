import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nandu/Services/firebase_auth_config.dart';
import 'package:nandu/screens/home.dart';
import 'package:nandu/screens/sign_in_with_otp.dart';
import 'package:nandu/screens/sign_up.dart';
import 'login.dart';
import 'terms_conditions.dart';

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
                  top: height10 * 2,
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
              Stack(
                children: [
                  SvgPicture.asset(
                    'assets/images/Illustration.svg',
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    bottom: 0,
                    // left: 40,
                    // right: 40,
                    child: Center(
                      child: SizedBox(
                        width: Get.width,
                        child: RichText(
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
                                    Get.to(() => const TermsAndConditions());
                                  },
                              ),
                              TextSpan(
                                text:
                                    " and confirm that I have read\nNandur’s ",
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
                                    Get.to(() => const TermsAndConditions());
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: height10 * 2.0),
                child: Column(
                  children: [
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
                        Get.to(() => const SignInWithOTP());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset("assets/icons/bxs_mobile.svg"),
                          const Spacer(),
                          Text(
                            "Continue with OTP",
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
                        FirebaseAuthConfig().signInWithGoogle();
                        FirebaseAuthConfig().storeData(
                          FirebaseAuth.instance.currentUser!.displayName
                              .toString(),
                          FirebaseAuth.instance.currentUser!.email.toString(),
                          FirebaseAuth.instance.currentUser!.phoneNumber
                              .toString(),
                        );
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
                        FirebaseAuthConfig()
                            .signInWithFacebook(facebookEmail, facebookName);
                        FirebaseAuthConfig().storeData(facebookName.toString(),
                            facebookEmail.toString(), "null");
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
                        Expanded(
                          child: ElevatedButton(
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
                              Get.to(() => const Login());
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
                        ),
                        SizedBox(width: height10 * 1.2),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFF00880D),
                              elevation: 0.0,
                              minimumSize:
                                  Size(height10 * 15.4, height10 * 4.8),
                            ),
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
}
