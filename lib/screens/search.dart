import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00880D),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF00880D),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Search",
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0 - MediaQuery.of(context).viewInsets.bottom,
            child: Container(
              height: Get.height * 0.825,
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 18,
            child: Container(
              height: 150,
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 12),
                    blurRadius: 30,
                    color: Color(0x1A000000),
                  ),
                ],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextFormField(
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        icon: SizedBox(
                          child: SvgPicture.asset("assets/icons/pin.svg"),
                          width: 50,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusColor: Colors.transparent,
                        constraints: BoxConstraints(
                          maxHeight: 70,
                          maxWidth: 320,
                        )),
                  ),
                  Divider(
                    color: Color(0xFFC7C7CC),
                    thickness: 1,
                    height: 1,
                  ),
                  TextFormField(
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        icon: SizedBox(
                          child:
                              SvgPicture.asset("assets/icons/navigation.svg"),
                          width: 50,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusColor: Colors.transparent,
                        constraints: BoxConstraints(
                          maxHeight: 70,
                          maxWidth: 320,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
