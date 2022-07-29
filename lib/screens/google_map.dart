import 'dart:ui' as ui;
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nandu/screens/scanner.dart';
import 'dart:ui' as ui;
import '../.env.dart';

class GoogleMapLoc extends StatefulWidget {
  const GoogleMapLoc({Key? key}) : super(key: key);

  @override
  State<GoogleMapLoc> createState() => _GoogleMapLocState();
}

class _GoogleMapLocState extends State<GoogleMapLoc> {
  static LatLng destination = const LatLng(
    17.407354,
    78.439974,
  );
  late BitmapDescriptor cyclesIcon;
  late BitmapDescriptor currentIcon;
  late BitmapDescriptor destinationIcon;
  PolylinePoints polylinePoints = PolylinePoints();
  LocationData? currentLocation;
  List<LatLng> polylineCoordinates = [];
  LatLng? selectedPosition;
  String? distance;
  bool selectedMarker = false;

  @override
  void initState() {
    getCurrentLocation();
    cyclesMarkerIcon();
    userMarkerIcon();
    destinationMarkerIcon();
    super.initState();
  }

  destinationMarkerIcon() async {
    final Uint8List destinationMarkerIcon =
        await getBytesFromAsset('assets/icons/Pin.png', 100);
    setState(() {
      destinationIcon = BitmapDescriptor.fromBytes(destinationMarkerIcon);
    });
  }

  userMarkerIcon() async {
    final Uint8List userMarkerIcon =
        await getBytesFromAsset('assets/icons/profile.png', 200);
    setState(() {
      currentIcon = BitmapDescriptor.fromBytes(userMarkerIcon);
    });
  }

  cyclesMarkerIcon() async {
    final Uint8List cyclesMarkerIcon =
        await getBytesFromAsset('assets/icons/bike.png', 100);
    setState(() {
      cyclesIcon = BitmapDescriptor.fromBytes(cyclesMarkerIcon);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  int calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return (12742 * asin(sqrt(a)) * 1000).toInt();
  }

  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        setState(() {
          currentLocation = location;
        });
      },
    );
  }

  getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(selectedPosition!.latitude, selectedPosition!.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      setState(() {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
          );
        });
      });
    }
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    Stack(
                      children: [
                        Positioned(
                          top: 0,
                          child: SizedBox(
                            height: 700,
                            width: Get.width,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  currentLocation!.latitude!,
                                  currentLocation!.longitude!,
                                ),
                                zoom: 17.5,
                              ),
                              polylines: {
                                Polyline(
                                  polylineId: PolylineId("route"),
                                  points: polylineCoordinates,
                                  color: const Color(0xFF00880D),
                                  width: 10,
                                ),
                              },
                              markers: {
                                Marker(
                                  markerId: const MarkerId("Current Location"),
                                  icon: currentIcon,
                                  position: LatLng(
                                    currentLocation!.latitude!,
                                    currentLocation!.longitude!,
                                  ),
                                ),
                                Marker(
                                  markerId: const MarkerId("Destination"),
                                  icon: destinationIcon,
                                  position: LatLng(
                                    17.407354,
                                    78.439974,
                                  ),
                                ),
                                Marker(
                                  onTap: selectedMarker == true
                                      ? null
                                      : () {
                                          setState(() {
                                            selectedPosition =
                                                LatLng(17.412663, 78.437547);
                                            distance = calculateDistance(
                                              selectedPosition!.latitude,
                                              selectedPosition!.longitude,
                                              destination.latitude,
                                              destination.longitude,
                                            ).toString();

                                            selectedMarker == true
                                                ? polylineCoordinates.add(
                                                    LatLng(
                                                      selectedPosition!
                                                          .latitude,
                                                      selectedPosition!
                                                          .longitude,
                                                    ),
                                                  )
                                                : null;
                                            // sourceLocation = LatLng(
                                            //   currentLocation!.latitude!,
                                            //   currentLocation!.longitude!,
                                            // );
                                            // destination =
                                            //     LatLng(17.412663, 78.437547);
                                          });
                                        },
                                  visible: !selectedMarker,
                                  icon: cyclesIcon,
                                  markerId: MarkerId("Cycle_1"),
                                  position: LatLng(17.412663, 78.437547),
                                ),
                                Marker(
                                  onTap: selectedMarker == true
                                      ? null
                                      : () {
                                          setState(() {
                                            selectedPosition =
                                                LatLng(17.412165, 78.437453);
                                            distance = calculateDistance(
                                              selectedPosition!.latitude,
                                              selectedPosition!.longitude,
                                              destination.latitude,
                                              destination.longitude,
                                            ).toString();

                                            selectedMarker == true
                                                ? polylineCoordinates.add(
                                                    LatLng(
                                                      selectedPosition!
                                                          .latitude,
                                                      selectedPosition!
                                                          .longitude,
                                                    ),
                                                  )
                                                : null;
                                          });
                                        },
                                  visible: !selectedMarker,
                                  icon: cyclesIcon,
                                  markerId: MarkerId("Cycle_2"),
                                  position: LatLng(17.412165, 78.437453),
                                ),
                                Marker(
                                  onTap: selectedMarker == true
                                      ? null
                                      : () {
                                          setState(() {
                                            selectedPosition =
                                                LatLng(17.410845, 78.437407);
                                            distance = calculateDistance(
                                              selectedPosition!.latitude,
                                              selectedPosition!.longitude,
                                              destination.latitude,
                                              destination.longitude,
                                            ).toString();

                                            selectedMarker == true
                                                ? polylineCoordinates.add(
                                                    LatLng(
                                                      selectedPosition!
                                                          .latitude,
                                                      selectedPosition!
                                                          .longitude,
                                                    ),
                                                  )
                                                : null;
                                          });
                                        },
                                  visible: !selectedMarker,
                                  icon: cyclesIcon,
                                  markerId: MarkerId("Cycle_3"),
                                  position: LatLng(17.410845, 78.437407),
                                ),
                                Marker(
                                  onTap: selectedMarker == true
                                      ? null
                                      : () {
                                          setState(() {
                                            selectedPosition =
                                                LatLng(17.412186, 78.436651);
                                            distance = calculateDistance(
                                              selectedPosition!.latitude,
                                              selectedPosition!.longitude,
                                              destination.latitude,
                                              destination.longitude,
                                            ).toString();

                                            selectedMarker == true
                                                ? polylineCoordinates.add(
                                                    LatLng(
                                                      selectedPosition!
                                                          .latitude,
                                                      selectedPosition!
                                                          .longitude,
                                                    ),
                                                  )
                                                : null;
                                          });
                                        },
                                  visible: !selectedMarker,
                                  icon: cyclesIcon,
                                  markerId: MarkerId("Cycle_4"),
                                  position: LatLng(17.412186, 78.436651),
                                ),
                                Marker(
                                  onTap: selectedMarker == true
                                      ? null
                                      : () {
                                          setState(() {
                                            selectedPosition =
                                                LatLng(17.410625, 78.437251);
                                            distance = calculateDistance(
                                              selectedPosition!.latitude,
                                              selectedPosition!.longitude,
                                              destination.latitude,
                                              destination.longitude,
                                            ).toString();

                                            selectedMarker == true
                                                ? polylineCoordinates.add(
                                                    LatLng(
                                                      selectedPosition!
                                                          .latitude,
                                                      selectedPosition!
                                                          .longitude,
                                                    ),
                                                  )
                                                : null;
                                          });
                                        },
                                  visible: !selectedMarker,
                                  icon: cyclesIcon,
                                  markerId: const MarkerId("Cycle_5"),
                                  position: LatLng(17.410625, 78.437251),
                                ),
                              },
                            ),
                          ),
                        ),
                        if (distance != null)
                          selectedMarker == false
                              ? Positioned(
                                  bottom: 0,
                                  child: SizedBox(
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                RichText(
                                                  textAlign: TextAlign.end,
                                                  text: TextSpan(
                                                    text:
                                                        "Haibike Sduro FullSeven\nDistance",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: " $distance m",
                                                        style: TextStyle(
                                                          fontSize: 21,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedMarker = true;
                                                      getPolyPoints();
                                                    });
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    primary: Color(0xFFC7C7CC),
                                                    minimumSize: Size(100, 30),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Continue",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                          child: Image.asset(
                                            "assets/images/Bitmap.png",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Positioned(
                                  bottom: 0,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 30, right: 16, left: 30),
                                    alignment: Alignment.topCenter,
                                    height: 220,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00880B),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(50)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            text: "Per 30 mins\n",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "\$ 0.50",
                                                style: TextStyle(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            text: "Distance\n",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "$distance m",
                                                style: TextStyle(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          textAlign: TextAlign.end,
                                          text: TextSpan(
                                            text: "Estimated Time\n",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: int.parse(distance!) >
                                                        1000
                                                    ? "10 mins"
                                                    : int.parse(distance!) > 500
                                                        ? "7.5 mins"
                                                        : "5 mins",
                                                style: TextStyle(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
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
                    Scanner(),
                    Center(
                      child: SvgPicture.asset(
                        "assets/icons/settings.svg",
                        color: const Color(0xFF00880D),
                      ),
                    ),
                  ],
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
      // bottomNavigationBar: Container(
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
    );
  }
}
