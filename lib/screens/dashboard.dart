import 'package:flutter/material.dart';
import 'package:minimarket/theme/color.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Beranda',
          style: TextStyle(
            color: ThemeColors().textWhite,
          ),
        ),
        backgroundColor: ThemeColors().backgroundBlue,
      ),
    );
  }
}
