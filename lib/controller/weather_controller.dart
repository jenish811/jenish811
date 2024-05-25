import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_place/google_place.dart';
import 'package:http/http.dart' as http;

class WeatherController extends GetxController {
  RxString apiKey = '1069cf0e7a4740f79b9103813232812'.obs;

  RxList weatherDataList = [].obs;
  RxMap weatherData = {}.obs;
  RxMap weatherCity = {}.obs;
  RxList<AutocompletePrediction> autoComplete = <AutocompletePrediction>[].obs;
  final TextEditingController cityController = TextEditingController();

  var googlePlace = GooglePlace("AIzaSyD1YWqeblqJSAimHX_kEiEzQ2lP2_EDTv8");
  double lat = 88.3639;
  double lon = 22.5726;

  void autoCompleteSearch(String value) async {
    Future.delayed(Duration.zero, () {});
    var result = await googlePlace.autocomplete.get(value, location: LatLon(lat, lon), origin: LatLon(lat, lon), components: [Component("country", "in")]);
    if (result != null && result.predictions != null && result.predictions!.isNotEmpty) {
      autoComplete.value = result.predictions!;
    }
  }

  Future weatherAPI({
    String? city,
  }) async {
    var url = "https://api.weatherapi.com/v1/forecast.json?q=$city&days=7&key=${apiKey.value}";
    final response = await http.get(
      Uri.parse(url),
    );
    debugPrint("-=-=-=-url-=-=-=$url");
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      debugPrint("data is == $data");
      weatherDataList.value = data["forecast"]['forecastday'];
      weatherData.value = data["current"];
      weatherCity.value = data["location"];
    } else {
      final snackBar = SnackBar(
        content: Text(
          'Failed to load weather data !',
          style: GoogleFonts.quicksand(fontSize: 14.0, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      );
      ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
      throw Exception('Failed to load weather data');
    }
  }
}
