import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/controller/weather_controller.dart';

class CurrentLocationController extends GetxController {
  static const int locationTimeoutInSeconds = 2; // Timeout for location request
  RxString cityName = "Unknown".obs;

  Future<void> listenToLocationServiceChanges() async {
    final hasPermission = await _handleLocationPermission();
    if (hasPermission) {
      Position? lastKnownPosition = await Geolocator.getLastKnownPosition();
      if (lastKnownPosition != null) {
        currentPosition = lastKnownPosition;
        debugPrint("currentPosition == $currentPosition");
        if (currentPosition != null) {
          cityName.value = "";
          getCurrentWeather(currentPosition!.latitude, currentPosition!.longitude);
        }
      }
    }
  }

  Future<void> getCurrentWeather(double lat, double long) async {
    final WeatherController weatherController = Get.put(WeatherController());

    List<Placemark> placeMarks = await placemarkFromCoordinates(lat, long);
    Placemark place = placeMarks[0];
    cityName.value = place.locality ?? "Unknown";
    weatherController.weatherDataList.clear();
    weatherController.weatherData.clear();
    weatherController.weatherCity.clear();
    weatherController.autoComplete.clear();
    weatherController.autoComplete.clear();
    if(cityName.value != "Unknown"){
      await weatherController.weatherAPI(city: cityName.value);
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text(
        'Location services are disabled. Please enable the services',
        style: GoogleFonts.quicksand(fontSize: 14.0, fontWeight: FontWeight.w700, color: Colors.white),
      )));

      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: Text(
          'Location permissions are denied',
          style: GoogleFonts.quicksand(fontSize: 14.0, fontWeight: FontWeight.w700, color: Colors.white),
        )));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text(
        'Location permissions are permanently denied, we cannot request permissions.',
        style: GoogleFonts.quicksand(fontSize: 14.0, fontWeight: FontWeight.w700, color: Colors.white),
      )));
      return false;
    }
    return true;
  }

  Position? currentPosition;
}
