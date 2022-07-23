import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapLoc extends StatefulWidget {
  const GoogleMapLoc({Key? key}) : super(key: key);

  @override
  State<GoogleMapLoc> createState() => _GoogleMapLocState();
}

class _GoogleMapLocState extends State<GoogleMapLoc> {
  // final Completer<GoogleMapController> mapController = Completer();
  static const LatLng sourceLocation = LatLng(17.412663, 78.437547);
  static const LatLng destination = LatLng(17.412165, 78.437453);
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [
    LatLng(17.412663, 78.437547),
    LatLng(17.412165, 78.437453),
  ];
  PolylinePoints polylinePoints = PolylinePoints();
  String google_api_key = "AIzaSyAD3B4_0z0Rnrx6sqqnJ5noAqxv4wTJkIw";
  LocationData? currentLocation;

  @override
  void initState() {
    getCurrentLocation();
    getPolyPoints();
    super.initState();
  }

  void getCurrentLocation() {
    Location location = Location();
    location.getLocation().then(
      (location) {
        log("got location data");
        setState(() {
          currentLocation = location;
        });
      },
    );
  }

  getPolyPoints() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: currentLocation == null
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF00880D),
                ),
              )
            : Stack(
                children: [
                  IndexedStack(
                    index: selectedIndex,
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            currentLocation!.latitude!,
                            currentLocation!.longitude!,
                          ),
                          zoom: 17.5,
                        ),
                        polylines: {
                          Polyline(
                            polylineId: const PolylineId("route"),
                            points: polylineCoordinates,
                            color: const Color(0xFF00880D),
                            width: 10,
                          ),
                        },
                        markers: {
                          Marker(
                            markerId: const MarkerId("Current Location"),
                            position: LatLng(
                              currentLocation!.latitude!,
                              currentLocation!.longitude!,
                            ),
                          ),
                          const Marker(
                            markerId: MarkerId("source"),
                            position: sourceLocation,
                          ),
                          const Marker(
                            markerId: MarkerId("destination"),
                            position: destination,
                          ),
                        },
                      ),
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: sourceLocation,
                          zoom: 13.5,
                        ),
                        polylines: {
                          Polyline(
                            polylineId: const PolylineId("route"),
                            points: polylineCoordinates,
                            color: const Color(0xFF00880D),
                            width: 10,
                          ),
                        },
                        markers: {
                          // Marker(
                          //   markerId: const MarkerId("Current Location"),
                          //   position: LatLng(
                          //     currentLocation!.latitude!,
                          //     currentLocation!.longitude!,
                          //   ),
                          // ),
                          const Marker(
                            // icon: BitmapDescriptor.fromAssetImage(
                            //    empty,
                            //     "assets/icons/profile.png"),
                            markerId: MarkerId("source"),
                            position: sourceLocation,
                          ),
                          const Marker(
                            markerId: MarkerId("destination"),
                            position: destination,
                          ),
                        },
                      ),
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: sourceLocation,
                          zoom: 13.5,
                        ),
                        polylines: {
                          Polyline(
                            polylineId: const PolylineId("route"),
                            points: polylineCoordinates,
                            color: const Color(0xFF00880D),
                            width: 10,
                          ),
                        },
                        markers: {
                          const Marker(
                            markerId: MarkerId("source"),
                            position: sourceLocation,
                          ),
                          const Marker(
                            markerId: MarkerId("destination"),
                            position: destination,
                          ),
                        },
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 280,
                      width: Get.width,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              height: 250,
                              width: Get.width,
                              color: Color(0xFF00880D),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.end,
                                    text: TextSpan(
                                      text: "Haibike Sduro FullSeven\nDistance",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: " 150 m",
                                          style: TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: Color(0xFFC7C7CC),
                                      minimumSize: Size(100, 30),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      "Continue",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 170,
                              left: -40,
                              child: Image.asset("assets/images/Bitmap.png")),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: Get.width,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 12),
                            blurRadius: 30,
                            color: Color(0x29000000),
                          )
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = 0;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/compass_select.svg",
                                  height: 24.0,
                                  color: selectedIndex == 0
                                      ? null
                                      : Color(0xFFC2C2C2),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: selectedIndex == 0 ? 6 : 0,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF00880D),
                                      borderRadius: BorderRadius.circular(3)),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = 1;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/unlock.svg",
                                  height: 24.0,
                                  color: selectedIndex == 1
                                      ? Color(0xFF00880D)
                                      : Color(0xFFC2C2C2),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: selectedIndex == 1 ? 6 : 0,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF00880D),
                                      borderRadius: BorderRadius.circular(3)),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = 2;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/settings.svg",
                                  height: 24.0,
                                  color: selectedIndex == 2
                                      ? Color(0xFF00880D)
                                      : Color(0xFFC2C2C2),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: selectedIndex == 2 ? 6 : 0,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF00880D),
                                      borderRadius: BorderRadius.circular(3)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        // Container(
        //   width: Get.width,
        //   height: 130,
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     boxShadow: [
        //       BoxShadow(
        //         offset: Offset(0, 12),
        //         blurRadius: 30,
        //         color: Color(0x29000000),
        //       )
        //     ],
        //     borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(50),
        //     ),
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       InkWell(
        //         onTap: () {
        //           setState(() {
        //             selectedIndex = 0;
        //           });
        //         },
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             SvgPicture.asset(
        //               "assets/icons/compass_select.svg",
        //               height: 24.0,
        //               color: selectedIndex == 0 ? null : Color(0xFFC2C2C2),
        //             ),
        //             const SizedBox(height: 10),
        //             Container(
        //               height: selectedIndex == 0 ? 6 : 0,
        //               width: 30,
        //               decoration: BoxDecoration(
        //                   color: Color(0xFF00880D),
        //                   borderRadius: BorderRadius.circular(3)),
        //             ),
        //           ],
        //         ),
        //       ),
        //       InkWell(
        //         onTap: () {
        //           setState(() {
        //             selectedIndex = 1;
        //           });
        //         },
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             SvgPicture.asset(
        //               "assets/icons/unlock.svg",
        //               height: 24.0,
        //               color: selectedIndex == 1
        //                   ? Color(0xFF00880D)
        //                   : Color(0xFFC2C2C2),
        //             ),
        //             const SizedBox(height: 10),
        //             Container(
        //               height: selectedIndex == 1 ? 6 : 0,
        //               width: 30,
        //               decoration: BoxDecoration(
        //                   color: Color(0xFF00880D),
        //                   borderRadius: BorderRadius.circular(3)),
        //             ),
        //           ],
        //         ),
        //       ),
        //       InkWell(
        //         onTap: () {
        //           setState(() {
        //             selectedIndex = 2;
        //           });
        //         },
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             SvgPicture.asset(
        //               "assets/icons/settings.svg",
        //               height: 24.0,
        //               color: selectedIndex == 2
        //                   ? Color(0xFF00880D)
        //                   : Color(0xFFC2C2C2),
        //             ),
        //             const SizedBox(height: 10),
        //             Container(
        //               height: selectedIndex == 2 ? 6 : 0,
        //               width: 30,
        //               decoration: BoxDecoration(
        //                   color: Color(0xFF00880D),
        //                   borderRadius: BorderRadius.circular(3)),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
