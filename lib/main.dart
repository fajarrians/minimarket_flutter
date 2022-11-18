import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimarket/layouts/bottomNav.dart';
import 'package:minimarket/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var dataUser;
  var redirect;

  @override
  void initState() {
    super.initState();
    _loadDataUser();
  }

  _loadDataUser() async {
    final localStorage = await SharedPreferences.getInstance();
    setState(() {
      dataUser = localStorage.getString('data');
      if (dataUser == null) {
        redirect = const LoginScreen();
      } else {
        redirect = const BottomNav();
      }
    });
    print(dataUser);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      home: redirect,
    );
  }
}
