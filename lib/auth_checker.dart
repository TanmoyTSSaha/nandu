import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nandu/screens/home.dart';
import 'package:nandu/screens/sign_In_options.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return snapshot.data != null ? const Home() : const SignInOptions();
      },
    );
  }
}
