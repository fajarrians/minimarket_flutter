import 'package:flutter/material.dart';
import 'package:minimarket/screens/account/account.dart';
import 'package:minimarket/screens/dashboard.dart';
import 'package:minimarket/screens/report.dart';
import 'package:minimarket/theme/color.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedNavbar = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    ReportScreen(),
    AccountScreen(),
  ];

  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: _widgetOptions.elementAt(_selectedNavbar),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
        currentIndex: _selectedNavbar,
        selectedItemColor: ThemeColors().blue4,
        unselectedItemColor: ThemeColors().textGrey,
        showUnselectedLabels: true,
        onTap: _changeSelectedNavBar,
      ),
    );
  }
}
