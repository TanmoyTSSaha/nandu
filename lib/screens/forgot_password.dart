import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nandu/Services/firebase_auth_config.dart';
import 'package:nandu/screens/sign_in_verification.dart';
import 'package:nandu/screens/sign_up.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> signInFormormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
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
            padding: EdgeInsets.symmetric(horizontal: height10 * 2.0),
            child: Form(
              key: signInFormormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: height10 * 2.4,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF00880D),
                    ),
                  ),
                  SizedBox(height: height10 * 4),
                  Text(
                    "Email Address",
                    style: TextStyle(
                      fontSize: height10 * 1.2,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                  SizedBox(height: height10 * 0.8),
                  TextFormField(
                    validator: (email) {
                      if (email!.isEmpty) {
                        return "Mobile number cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email_outlined,
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
                      hintText: " Enter your email address",
                      hintStyle: TextStyle(
                        fontSize: height10 * 1.5,
                        color: const Color(0xFFC2C2C2),
                      ),
                    ),
                  ),
                  SizedBox(height: height10 * 45),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF00880D),
                        elevation: 0.0,
                        minimumSize: Size(double.infinity, height10 * 4.8)),
                    onPressed: () {
                      if (signInFormormKey.currentState!.validate()) {
                        FirebaseAuthConfig()
                            .resetPassword(emailController.text);
                      }
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: height10 * 1.5,
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
