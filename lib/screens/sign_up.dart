import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nandu/Services/firebase_auth_config.dart';
import 'package:nandu/controllers/controller.dart';
import 'package:nandu/screens/sign_in_with_otp.dart';
import 'package:nandu/screens/sign_up_verification.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Controller controller = Get.put(Controller());
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double height10 = screenHeight / 78;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(height10 * 2),
            child: Form(
              key: signUpFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: height10 * 2.4,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF00880D),
                    ),
                  ),
                  SizedBox(height: height10),
                  Text(
                    "Sign in to your account",
                    style: TextStyle(
                      fontSize: height10 * 1.4,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                  SizedBox(height: height10 * 4 > 10 ? 10 : height10 * 4),
                  Text(
                    "Username",
                    style: TextStyle(
                      fontSize: height10 * 1.2,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                  SizedBox(height: height10 * 0.8),
                  TextFormField(
                    controller: usernameController,
                    validator: (username) {
                      if (username!.isEmpty) {
                        return "Username cannot be empty!";
                      } else {
                        return null;
                      }
                    },
                    autocorrect: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person_rounded,
                        color: Color(0xFFC2C2C2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: height10 * 0.1,
                          color: Colors.red,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: height10 * 0.1,
                          color: const Color(0xFFEDEDED),
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: height10 * 0.1,
                          color: const Color(0xFFEDEDED),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: height10 * 0.1,
                          color: const Color(0xFFEDEDED),
                        ),
                      ),
                      hintText: " Enter your username",
                      hintStyle: TextStyle(
                        fontSize: height10 * 1.5,
                        color: const Color(0xFFC2C2C2),
                      ),
                    ),
                  ),
                  SizedBox(height: height10 * 2),
                  Text(
                    "Email",
                    style: TextStyle(
                      fontSize: height10 * 1.2,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                  SizedBox(height: height10 * 0.8),
                  TextFormField(
                    controller: emailAddressController,
                    validator: (email) {
                      if (email!.isEmpty) {
                        return "Email cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email_rounded,
                        color: Color(0xFFC2C2C2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: height10 * 0.1,
                          color: Colors.red,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: height10 * 0.1,
                          color: const Color(0xFFEDEDED),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: height10 * 0.1,
                          color: const Color(0xFFEDEDED),
                        ),
                      ),
                      hintText: " Enter your email",
                      hintStyle: TextStyle(
                        fontSize: height10 * 1.5,
                        color: const Color(0xFFC2C2C2),
                      ),
                    ),
                  ),
                  SizedBox(height: height10 * 2),
                  Text(
                    "Mobile number",
                    style: TextStyle(
                      fontSize: height10 * 1.2,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                  SizedBox(height: height10 * 0.8),
                  TextFormField(
                    controller: phoneNumberController,
                    validator: (phoneNumber) {
                      if (phoneNumber!.isEmpty) {
                        return "Mobile number cannot be empty";
                      }
                      if (phoneNumber.length < 10) {
                        return "Please enter a valid mobile number";
                      } else {
                        return null;
                      }
                    },
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    decoration: InputDecoration(
                      counterText: '',
                      prefixIcon: Image.asset("assets/icons/india.png"),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: height10 * 0.1,
                          color: Colors.red,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: height10 * 0.1,
                          color: const Color(0xFFEDEDED),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: height10 * 0.1,
                          color: const Color(0xFFEDEDED),
                        ),
                      ),
                      hintText: " Enter mobile number",
                      hintStyle: TextStyle(
                        fontSize: height10 * 1.5,
                        color: const Color(0xFFC2C2C2),
                      ),
                    ),
                  ),
                  SizedBox(height: height10 * 2),
                  Text(
                    "Password",
                    style: TextStyle(
                      fontSize: height10 * 1.2,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                  SizedBox(height: height10 * 0.8),
                  TextFormField(
                    controller: passwordController,
                    validator: (password) {
                      if (password!.length < 6) {
                        return "Password must be atleast of 6 characters";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !showPassword,
                    autocorrect: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock_rounded,
                        color: Color(0xFFC2C2C2),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                            log(showPassword.toString());
                          });
                        },
                        icon: showPassword == true
                            ? const Icon(CupertinoIcons.eye)
                            : const Icon(CupertinoIcons.eye_slash),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: height10 * 0.1,
                          color: Colors.red,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: height10 * 0.1,
                          color: const Color(0xFFEDEDED),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: height10 * 0.1,
                          color: const Color(0xFFEDEDED),
                        ),
                      ),
                      hintText: "Enter your password",
                      hintStyle: TextStyle(
                        fontSize: height10 * 1.5,
                        color: const Color(0xFFC2C2C2),
                      ),
                    ),
                  ),
                  SizedBox(height: height10 * 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF00880D),
                        elevation: 0.0,
                        minimumSize: Size(double.infinity, height10 * 4.8)),
                    onPressed: () {
                      if (signUpFormKey.currentState!.validate()) {
                        try {
                          FirebaseAuthConfig().signUpWithEmailAndPassword(
                            emailAddressController.text,
                            passwordController.text,
                          );
                          try {
                            Get.to(
                              () => SignUpVerification(
                                emailAddress: emailAddressController.text,
                                password: passwordController.text,
                                phoneNumber: phoneNumberController.text,
                                username: usernameController.text,
                              ),
                            );
                          } catch (e) {
                            log(e.toString());
                          }
                        } catch (e) {
                          log(e.toString());
                        }
                      }
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: height10 * 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: height10 * 2),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have a account ? ",
                        style: TextStyle(
                          fontSize: height10 * 1.2,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFFC2C2C2),
                        ),
                        children: [
                          TextSpan(
                            text: "Sign In",
                            style: TextStyle(
                              fontSize: height10 * 1.2,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF00880D),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => const SignInWithOTP());
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
