import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/screen/weather_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  bool isCompleteLoad = false;

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _initAnimations() {
    _slideController = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from the bottom
      end: const Offset(0, 0), // End at the top
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.fastOutSlowIn,
    ));
  }

  void _startAnimations() {
    _slideController.forward();
  }

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
    preDataLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.blue
        ,
      body: Center(
        child: AnimatedBuilder(
          animation: _slideController,
          builder: (context, child) {
            return SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/weather.png",
                      scale: 4.0,
                    ),
                    Text(
                      "Weather forecast",
                      style: GoogleFonts.quicksand(fontSize: 24.0, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ],
                ));
          },
        ),
      ),
    );
  }

  preDataLoad() async {
    Timer(const Duration(seconds: 4), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const WeatherScreen())));
  }
}
