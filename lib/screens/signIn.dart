import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nandu/screens/signUp.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> signInFormormKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: height10 * 2.0),
          child: Form(
            key: signInFormormKey,
            child: Column(
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
                SizedBox(height: height10 * 4),
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
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.phone_android_rounded,
                      color: Color(0xFFC2C2C2),
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
                    hintText: " Enter your mobile number",
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
                SizedBox(height: height10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          fontSize: height10 * 1.2,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF00880D)),
                    ),
                  ),
                ),
                SizedBox(height: height10 * 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF00880D),
                      elevation: 0.0,
                      minimumSize: Size(double.infinity, height10 * 4.8)),
                  onPressed: () {
                    if (signInFormormKey.currentState!.validate()) {}
                  },
                  child: Text(
                    "Sign In",
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
                      text: "Don’t have an account ? ",
                      style: TextStyle(
                        fontSize: height10 * 1.2,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFFC2C2C2),
                      ),
                      children: [
                        TextSpan(
                          text: "Register",
                          style: TextStyle(
                            fontSize: height10 * 1.2,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF00880D),
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() => const SignUp());
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
    );
  }
}
