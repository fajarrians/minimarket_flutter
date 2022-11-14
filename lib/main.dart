import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimarket/layouts/bottomNav.dart';
import 'package:minimarket/screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      home: BottomNav(),
    );
  }
}
