import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nandu/screens/signInOptions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInOptions(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double height10 = screenHeight / 78;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: height10 * 3.8,
          width: height10 * 13,
          child: SvgPicture.asset("assets/icons/Logo.svg"),
        ),
      ),
    );
  }
}
