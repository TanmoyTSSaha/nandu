import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrkey = GlobalKey(debugLabel: 'QR');

  // void _onQRViewCreated(QRViewController controller) {
  //   setState(() => this.controller = controller);
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() => result = scanData);
  //   });
  // }

  @override
  void initState() {
    log("Scanner Runned!");
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
      log("Camera Paused");
    }
    if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  // void readQr() async {
  //   if (result != null) {
  //     controller!.pauseCamera();
  //     log(result!.code.toString());
  //     controller!.dispose();
  //   }
  // }
    void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return QRView(
      key: qrkey,
      cameraFacing: CameraFacing.back,
      onPermissionSet:(cntl, p) => _onPermissionSet(context, cntl, p),
      
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: const Color(0xFF00880B),
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 250,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
          setState(() {
      result = scanData;
    });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
