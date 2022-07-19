import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';

class LocalLockScreen extends StatefulWidget {
  const LocalLockScreen({Key? key}) : super(key: key);

  @override
  State<LocalLockScreen> createState() => _LocalLockScreenState();
}

class _LocalLockScreenState extends State<LocalLockScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
    _checkBiometrics();
    log("checkBiometrics : " + _checkBiometrics().toString());
    _getAvailableBiometrics();
    log("checkBiometrics : " + _getAvailableBiometrics().toString());
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double height10 = screenHeight / 78;
    return Scaffold(
      backgroundColor: Color(0xFF404040),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: height10 * 8,
            left: height10 * 2,
            right: height10 * 2,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Unlock Nandu App",
                  style: TextStyle(
                    fontSize: height10 * 2.4,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF00880D),
                  ),
                ),
                Text(
                  "Unlock Screen with PIN, patten, password, Face,or fingerprint",
                  style: TextStyle(
                    fontSize: height10 * 1.4,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9E9E9E),
                  ),
                ),
                SizedBox(height: height10 * 10),
                Center(
                  child: Text(
                    "Enter PIN",
                    style: TextStyle(
                      fontSize: height10 * 1.2,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                ),
                SizedBox(height: height10 * 0.8),
                Center(
                  child: Pinput(
                    length: 6,
                    controller: pinController,
                    defaultPinTheme: PinTheme(
                      width: height10 * 4.5,
                      height: height10 * 4.5,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: height10 * 0.1,
                          color: const Color(0xFF00880D),
                        ),
                      ),
                      textStyle: TextStyle(
                        fontSize: height10 * 1.5,
                        color: Color(0xFFC2C2C2),
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
                        color: Color(0xFFC2C2C2),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height10 * 30.5),
                Center(
                  child: SvgPicture.asset(
                      "assets/icons/ion_finger-print-outline.svg"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
