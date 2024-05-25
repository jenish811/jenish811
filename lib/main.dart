import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/connectivity_service/connectivity_controller.dart';
import 'package:weather_app/screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Weather app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      initialBinding: BindingsBuilder(() {
        Get.put(ConnectivityController());
      }),
    );
  }
}
