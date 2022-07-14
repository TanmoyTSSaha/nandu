import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nandu/controllers/controller.dart';
import 'package:nandu/screens/home.dart';
import 'package:nandu/screens/signIn.dart';
import 'package:pinput/pinput.dart';

class Verification extends StatefulWidget {
  String username;
  String emailAddress;
  String phoneNumber;
  String password;
  Verification({
    Key? key,
    required this.username,
    required this.emailAddress,
    required this.phoneNumber,
    required this.password,
  }) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Controller controller = Get.put(Controller());
  // OtpFieldController otpController = OtpFieldController();
  TextEditingController otpController = TextEditingController();
  String _verificationCode = '';
  late Timer? countDownTimer;
  Duration timerDuration = const Duration(seconds: 31);
  int seconds = 31;
  @override
  void initState() {
    _verifyPhoneNumber();
    startTimer();
    super.initState();
  }

  void startTimer() {
    countDownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setTimer());
  }

  void stopTimer() {
    setState(() {
      countDownTimer!.cancel();
    });
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      timerDuration = const Duration(seconds: 31);
    });
  }

  void setTimer() {
    setState(() {
      seconds = timerDuration.inSeconds - 1;
      if (seconds <= 0) {
        countDownTimer!.cancel();
      } else {
        timerDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  void dispose() {
    countDownTimer;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: height10 * 2.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Verification",
                  style: TextStyle(
                    fontSize: height10 * 2.4,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF00880D),
                  ),
                ),
                SizedBox(height: height10),
                Text(
                  "Your verification OTP has been sent to +91123****890 number",
                  style: TextStyle(
                    fontSize: height10 * 1.4,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9E9E9E),
                  ),
                ),
                SizedBox(height: height10 * 2),
                Text(
                  "Enter OTP",
                  style: TextStyle(
                    fontSize: height10 * 1.2,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9E9E9E),
                  ),
                ),
                SizedBox(height: height10 * 0.8),
                Pinput(
                  length: 6,
                  controller: otpController,
                  onSubmitted: (pin) async {
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(
                        PhoneAuthProvider.credential(
                          verificationId: _verificationCode,
                          smsCode: pin,
                        ),
                      )
                          .then((value) async {
                        if (value.user != null) {
                          log("Pass to home");
                          Get.offAll(() => const Home());
                        }
                      });
                    } catch (e) {
                      FocusScope.of(context).unfocus();
                      _scaffoldKey.currentState!.showSnackBar(
                        const SnackBar(
                          content: Text("Invalid OTP"),
                        ),
                      );
                    }
                  },
                  defaultPinTheme: PinTheme(
                    width: height10 * 4.5,
                    height: height10 * 4.5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: height10 * 0.1,
                        color: const Color(0xFFC2C2C2),
                      ),
                    ),
                    textStyle: TextStyle(
                      fontSize: height10 * 1.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: height10 * 4.5,
                    height: height10 * 4.5,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: height10 * 0.1,
                          color: const Color(0xFF00880D)),
                    ),
                    textStyle: TextStyle(
                      fontSize: height10 * 1.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                // OTPTextField(
                //   length: 6,
                //   onChanged: (val) {},
                //   fieldWidth: 45,
                //   width: screenWidth,
                //   textFieldAlignment: MainAxisAlignment.start,
                //   controller: otpController,
                //   spaceBetween: 10,
                //   fieldStyle: FieldStyle.box,
                //   outlineBorderRadius: 0,
                //   style: TextStyle(
                //     fontSize: height10 * 1.5,
                //     color: const Color(0xFFC2C2C2),
                //   ),
                // ),
                SizedBox(height: height10 * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "00:$seconds Sec",
                      style: TextStyle(
                        fontSize: height10 * 1.2,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFFB344F),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (seconds == 0) {
                          resetTimer();
                          startTimer();
                          _verifyPhoneNumber();
                        }
                      },
                      child: Text(
                        "Re-send Code",
                        style: TextStyle(
                          fontSize: height10 * 1.2,
                          fontWeight: FontWeight.w400,
                          color: seconds == 0
                              ? const Color(0xFF00880D)
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height10 * 3),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF00880D),
                        elevation: 0.0,
                        minimumSize: Size(double.infinity, height10 * 4.8)),
                    onPressed: () {
                      PhoneAuthProvider.credential(
                        verificationId:
                            controller.verificationIDRecieved.toString(),
                        smsCode: otpController.toString(),
                      );
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
                  RichText(
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
                              Get.to(() => const SignIn());
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91 ${widget.phoneNumber}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            log("User logged In");
            Get.offAll(() => const Home());
          }
        });
      },
      verificationFailed: (FirebaseAuthException exception) {
        log(exception.toString());
        log(widget.phoneNumber);
      },
      codeSent: (verificationID, resendToken) {
        setState(() {
          _verificationCode = verificationID;
        });
      },
      codeAutoRetrievalTimeout: (verificationID) {
        setState(() {
          _verificationCode = verificationID;
        });
      },
      timeout: const Duration(seconds: 120),
    );
  }
}
