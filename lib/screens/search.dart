import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as lo;
import 'package:nandu/screens/google_map.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  lo.LocationData? currentLocation;
  String? Address;

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  Future<void> GetAddressFromLatLong(lo.LocationData? currentLocation) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation!.latitude!, currentLocation.longitude!);
    Placemark place = placemarks[0];
    setState(() {
      Address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      searchController = TextEditingController(text: Address);
    });
  }

  void getCurrentLocation() async {
    lo.Location location = lo.Location();
    location.getLocation().then(
      (location) {
        setState(() {
          currentLocation = location;
        });
      },
    );
  }

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
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Search",
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0 - MediaQuery.of(context).viewInsets.bottom,
            child: Container(
              padding: EdgeInsets.only(top: 125, left: 8, right: 8),
              height: Get.height * 0.825,
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      GetAddressFromLatLong(currentLocation);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.gps_fixed_rounded),
                        SizedBox(width: 12),
                        Text(
                          "Use current location",
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
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
                    controller: searchController,
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
                    // textInputAction: TextInputAction.route,
                    onFieldSubmitted: (v) {
                      Get.to(() => GoogleMapLoc());
                    },
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
