import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/controller/current_location_controller.dart';
import 'package:weather_app/controller/weather_controller.dart';
import 'package:weather_app/widget/no_data.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final weatherController = Get.put(WeatherController());
  final CurrentLocationController currentLocationController = Get.put(CurrentLocationController());

  @override
  void initState() {
    // TODO: implement initState
    currentLocationController.listenToLocationServiceChanges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Weather App',
            style: GoogleFonts.quicksand(fontSize: 18.0, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                currentLocationController.listenToLocationServiceChanges();
              },
              child: Text(
                "Get Current\nWeather",
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(fontSize: 14.0, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            )
          ],
          toolbarHeight: 60,
        ),
        body: Obx(
          () => Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 10, right: 10),
                child: TextField(
                  controller: weatherController.cityController,
                  style: GoogleFonts.quicksand(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                  cursorColor: const Color(0XFF9D9D9D),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      weatherController.autoCompleteSearch(value);
                    } else {
                      weatherController.autoComplete.clear();
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Search...".tr,
                    hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0XFF9D9D9D)),
                    suffixIcon: Container(
                      height: 20,
                      width: 70,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(27), bottomRight: Radius.circular(27)),
                        color: Colors.orange,
                      ),
                      child: Image.asset(
                        "assets/search-outline.png",
                        scale: 4,
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(27),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(27),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              weatherController.autoComplete.isNotEmpty
                  ? const SizedBox(
                      height: 12,
                    )
                  : const SizedBox(),
              weatherController.autoComplete.isNotEmpty
                  ? SizedBox(
                      height: 100,
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: weatherController.autoComplete.length,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          final add = weatherController.autoComplete[i];
                          return InkWell(
                            onTap: () async {
                              weatherController.weatherDataList.clear();
                              weatherController.weatherData.clear();
                              weatherController.weatherCity.clear();
                              weatherController.autoComplete.clear();
                              if (add.description != null) {
                                weatherController.cityController.text = add.description.toString().split(",").first;
                              }
                              weatherController.autoComplete.clear();
                              await weatherController.weatherAPI(city: weatherController.cityController.text);
                              weatherController.cityController.clear();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: Column(
                              children: [
                                locationData(
                                  add.description.toString().split(",").first,
                                  add.description.toString().split(",").sublist(1).join(",").trim(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15, right: 15, top: 7, bottom: 7),
                                  child: Container(
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              Text(
                weatherController.weatherCity["name"] != null ? weatherController.weatherCity["name"].toString() : "",
                style: GoogleFonts.quicksand(fontSize: 25.0, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              weatherController.weatherData.isNotEmpty
                  ? Image.network("https:${weatherController.weatherData["condition"]["icon"]}")
                  : Image.asset(
                      "assets/weather.png",
                      height: 130,
                      width: 500,
                    ),
              Text(
                weatherController.weatherData["temp_c"] != null ? "${weatherController.weatherData["temp_c"]} °C'" : "0 °C'",
                style: GoogleFonts.quicksand(fontSize: 25.0, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              weatherController.weatherData.isNotEmpty
                  ? Text(
                      weatherController.weatherData["condition"]["text"] != null ? "${weatherController.weatherData["condition"]["text"]}" : "",
                      style: GoogleFonts.quicksand(fontSize: 25.0, fontWeight: FontWeight.w700, color: Colors.white),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: weatherController.weatherDataList.isEmpty
                    ? noDataAvailable(message: "No data available")
                    : ListView.builder(
                        itemCount: weatherController.weatherDataList.length,
                        itemBuilder: (context, index) {
                          final data = weatherController.weatherDataList[index];
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    DateFormat("dd MMM yyyy, EEEE").format(DateTime.parse(data["date"])),
                                    style: GoogleFonts.quicksand(fontSize: 18.0, fontWeight: FontWeight.w700, color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    '${data["day"]["avgtemp_c"]} °C',
                                    style: GoogleFonts.quicksand(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.white),
                                  ),
                                ),
                                const Divider(
                                  color: Colors.white,
                                  height: 5,
                                )
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ));
  }

  locationData(
    String text1,
    String text2,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.quicksand(fontSize: 16.0, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(
                height: 2,
              ),
              SizedBox(
                width: Get.size.width / 100 * 80,
                child: Text(
                  text2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
