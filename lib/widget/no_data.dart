import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget noDataAvailable({@required String? message}) {
  return Center(
    child: Text(
      message.toString(),
      style: GoogleFonts.quicksand(fontSize: 25.0, fontWeight: FontWeight.w700, color: Colors.white),
    ),
  );
}
