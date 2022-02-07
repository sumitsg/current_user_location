// ignore_for_file: deprecated_member_use

import 'package:current_user_location/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'User Current location',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const DashBoardScreen());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? currentpostion;

  bool permissionGranted = false;
  String? currentAddress;
  String? latitude;
  String? longitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Current Location',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                size: 45.0,
                color: Colors.white,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Get User Location',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              currentAddress != null
                  ? Text(
                      '$currentAddress',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.linear_scale,
                      color: Colors.white,
                      size: 20,
                    ),
              const SizedBox(
                height: 5,
              ),
              FlatButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(7)),
                onPressed: () {
                  // getCurrentLocation();
                  _determinePosition();
                },
                child: const Text(
                  "Get Current Location",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              FlatButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(10)),
                onPressed: () {
                  googleMap();
                },
                child: const Text("open Google Map",
                    style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

// ! TO OPEN MAP URL
  void googleMap() async {
    String googleUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    // if (await canLaunch(googleUrl)) {
    await launch(googleUrl);
    // } else {
    // throw ("couldn't open application");
    // }
  }

  // ! TO GET CURRENT POSITION---------->
  Future _determinePosition() async {
    print('in function');
    bool serviceEnable;

    LocationPermission permission;

    serviceEnable = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnable) {
      Fluttertoast.showToast(
          msg: 'Please Enable Location Service', textColor: Colors.white);
    }
    // if (permissionGranted == true) {
    //   Fluttertoast.showToast(
    //       msg: 'Location permissions are already given.',
    //       textColor: Colors.white);
    // }
    // else {
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: 'Location Permission required', textColor: Colors.white);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.',
          textColor: Colors.white);
    }

    // if (permission == LocationPermission.always) {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    permissionGranted = true;

    try {
      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemark[4];

      setState(() {
        latitude = "${position.latitude}";
        longitude = "${position.longitude}";
        currentpostion = position;
        currentAddress =
            "${place.subLocality}, ${place.locality}, ${place.country}";
        print("${latitude} ${longitude}");
      });
    } catch (e) {
      print(e);
    }
    return position;
    // }
    // }
  }

  // void getCurrentLocation() async {
  //   var position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   var lati = position.latitude;
  //   var longi = position.longitude;

  //   latitude = "$lati";
  //   longitude = "$longi";

  //   setState(() {
  //     currentAddress = "Latitude: $lati and Longitude : $longi ";
  //   });
  // }
}
