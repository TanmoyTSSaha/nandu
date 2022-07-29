import 'dart:async';
import 'dart:developer';

import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as lo;
import 'package:nandu/Services/location_service.dart';
import 'package:nandu/screens/google_map.dart';
import 'package:google_maps_webservice/places.dart';
import '../.env.dart';
import "package:google_maps_webservice/places.dart";

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController searchDestinationController = TextEditingController();
  lo.LocationData? currentLocation;
  Mode _mode = Mode.overlay;
  String? Address;

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  List suggestions = [];

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
      backgroundColor: const Color(0xFF00880D),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF00880D),
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
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
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
                    ),
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: suggestions.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 10,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: InkWell(
                              onTap: () {},
                              child: Text(
                                suggestions[index],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            SizedBox(height: 5),
                            Divider(
                              height: 1,
                              color: Color(0xFFC7C7CC),
                            ),
                            SizedBox(height: 5),
                          ],
                        );
                      },
                    ),
                  ],
                ),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        hintText: "Enter location",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          // color: Colors.black,
                        ),
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
                    controller: searchDestinationController,
                    onChanged: (val) async {
                      if(val == null ) {
                        setState(() {
                          suggestions = [];
                        });
                      }
                      String places = await LocationService().getPlace(val);
                      setState(() {
                        suggestions.add(places);
                      });
                    },
                    style: TextStyle(
                      fontSize: 16,
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
                        hintText: 'Enter Destination',
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

//   Widget _buildDropdownMenu() => DropdownButton(
//         value: _mode,
//         items: <DropdownMenuItem<Mode>>[
//           DropdownMenuItem<Mode>(
//             child: Text("Overlay"),
//             value: Mode.overlay,
//           ),
//           DropdownMenuItem<Mode>(
//             child: Text("Fullscreen"),
//             value: Mode.fullscreen,
//           ),
//         ],
//         onChanged: (m) {
//           setState(() {
//             _mode = m as Mode;
//           });
//         },
//       );

//   void onError(PlacesAutocompleteResponse response) {
//     homeScaffoldKey.currentState!.showSnackBar(
//       SnackBar(content: Text(response.errorMessage!)),
//     );
//   }

//   Future<void> _handlePressButton() async {
//     // show input autocomplete with selected mode
//     // then get the Prediction selected
//     Prediction? p = await PlacesAutocomplete.show(
//       context: context,
//       apiKey: googleAPIKey,
//       onError: onError,
//       mode: _mode,
//       language: "fr",
//       decoration: InputDecoration(
//         hintText: 'Search',
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(
//             color: Colors.white,
//           ),
//         ),
//       ),
//       components: [Component(Component.country, "fr")],
//     );

//     displayPrediction(p!, homeScaffoldKey.currentState!);
//   }
// }

// Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
//   if (p != null) {
//     // get detail (lat/lng)
//     GoogleMapsPlaces _places = GoogleMapsPlaces(
//       apiKey: googleAPIKey,
//       apiHeaders: await GoogleApiHeaders().getHeaders(),
//     );
//     PlacesDetailsResponse detail =
//         await _places.getDetailsByPlaceId(p.placeId!);
//     final lat = detail.result.geometry!.location.lat;
//     final lng = detail.result.geometry!.location.lng;

//     scaffold.showSnackBar(
//       SnackBar(content: Text("${p.description} - $lat/$lng")),
//     );
//   }
}

// custom scaffold that handle search
// basically your widget need to extends [GooglePlacesAutocompleteWidget]
// and your state [GooglePlacesAutocompleteState]
// class CustomSearchScaffold extends PlacesAutocompleteWidget {
//   CustomSearchScaffold()
//       : super(
//           apiKey: googleAPIKey,
//           sessionToken: Uuid().generateV4(),
//           language: "en",
//           components: [Component(Component.country, "uk")],
//         );

//   @override
//   _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
// }

// class _CustomSearchScaffoldState extends PlacesAutocompleteState {
//   @override
//   Widget build(BuildContext context) {
//     final appBar = AppBar(title: AppBarPlacesAutoCompleteTextField());
//     final body = PlacesAutocompleteResult(
//       onTap: (p) {
//         displayPrediction(p, searchScaffoldKey.currentState!);
//       },
//       logo: Row(
//         children: [FlutterLogo()],
//         mainAxisAlignment: MainAxisAlignment.center,
//       ),
//     );
//     return Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
//   }

//   @override
//   void onResponseError(PlacesAutocompleteResponse response) {
//     super.onResponseError(response);
//     searchScaffoldKey.currentState!.showSnackBar(
//       SnackBar(content: Text(response.errorMessage!)),
//     );
//   }

//   @override
//   void onResponse(PlacesAutocompleteResponse? response) {
//     super.onResponse(response);
//     if (response != null && response.predictions.isNotEmpty) {
//       searchScaffoldKey.currentState!.showSnackBar(
//         SnackBar(content: Text("Got answer")),
//       );
//     }
//   }
// }

// class Uuid {
//   final Random _random = Random();

//   String generateV4() {
//     // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
//     final int special = 8 + _random.nextInt(4);

//     return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
//         '${_bitsDigits(16, 4)}-'
//         '4${_bitsDigits(12, 3)}-'
//         '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
//         '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
//   }

//   String _bitsDigits(int bitCount, int digitCount) =>
//       _printDigits(_generateBits(bitCount), digitCount);

//   int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

//   String _printDigits(int value, int count) =>
//       value.toRadixString(16).padLeft(count, '0');
// }
