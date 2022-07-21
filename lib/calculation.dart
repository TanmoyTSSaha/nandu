import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Calculation extends StatefulWidget {
  const Calculation({Key? key}) : super(key: key);

  @override
  State<Calculation> createState() => _CalculationState();
}

class _CalculationState extends State<Calculation> {
  TextEditingController receipts = TextEditingController(text: "0");
  // int  = 0;

  double ltrOfWater(int receipts) {
    return (2100 * receipts.toInt()) / 10000;
  }

  int trees(int receipts) {
    return ((1 * receipts.toInt()) / 10000).toInt();
  }

  double ltrOfOil(int receipts) {
    return (20 * receipts) / 10000;
  }

  double gmsOfCO2(int receipts) {
    double value = 0;
    setState(() {
      value = (26300 * receipts.toInt()) / 10000;
    });
    return value;
  }

  // int addReceipts(int receipts) {
  //   // int receipts = 0;
  //   setState(() {
  //     receipts += 1;
  //   });
  //   return receipts;
  // }

  // int minusReceipts(int receipts) {
  //   // int receipts = 0;
  //   setState(() {
  //     receipts -= 1;
  //   });
  //   return receipts;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          padding: EdgeInsets.all(20),
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "For",
                style: TextStyle(fontSize: 20),
              ),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == double) {
                    return "enter an integer number";
                  }
                },
                onChanged: (val) {
                  gmsOfCO2(int.parse(val.isNotEmpty ? val : "0"));
                },
                // onFieldSubmitted: (val) {
                //   gmsOfCO2(int.parse(val.isNotEmpty ? val : "0"));
                // },
                controller: receipts,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(width: 1, color: Colors.green),
                )),
              ),
              Text(
                "receipt(s), you can save:",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.amber),
                    width: 150,
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.water),
                        SizedBox(height: 10),
                        Text(
                          "${ltrOfWater(int.parse(receipts.text.isNotEmpty ? receipts.text : "0"))}\nLTR(S) OF WATER",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.amber),
                    width: 150,
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.tree),
                        SizedBox(height: 10),
                        Text(
                          "${trees(int.parse(receipts.text.isNotEmpty ? receipts.text : "0"))}\nTREE(S)",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.amber),
                    width: 150,
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.oil_barrel_outlined),
                        SizedBox(height: 10),
                        Text(
                          "${ltrOfOil(int.parse(receipts.text.isNotEmpty ? receipts.text : "0"))}\nLTR(S) OF OIL",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.amber),
                    width: 150,
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.co2_outlined),
                        SizedBox(height: 10),
                        Text(
                          "${gmsOfCO2(int.parse(receipts.text.isNotEmpty ? receipts.text : "0"))}\nGM(S) OF CO2",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
