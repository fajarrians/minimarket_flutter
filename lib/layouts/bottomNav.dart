import 'package:flutter/material.dart';
import 'package:minimarket/screens/account/account.dart';
import 'package:minimarket/screens/dashboard.dart';
import 'package:minimarket/screens/report.dart';
import 'package:minimarket/theme/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _changeSelectedNavBar();
  }

  _changeSelectedNavBar() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      String temp = localStorage.getString('index')!;
      _selectedNavbar = int.parse(temp);
      // _selectedNavbar = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedNavbar = index;
      setIndex(index.toString());
    });
  }

  setIndex(String index) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    localStorage.setString('index', index);
    _changeSelectedNavBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedNavbar),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_rounded),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Akun',
          ),
        ],
        currentIndex: _selectedNavbar,
        selectedItemColor: ThemeColors().backgroundBlue,
        unselectedItemColor: ThemeColors().textGrey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }
}
