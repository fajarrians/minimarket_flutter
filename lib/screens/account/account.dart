import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:minimarket/layouts/bottomNav.dart';
import 'package:minimarket/network/api.dart';
import 'package:minimarket/screens/change_password.dart';
import 'package:minimarket/screens/login.dart';
import 'package:minimarket/theme/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var user_id;
  var company_id;
  bool _isLoading = false;

  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('data')!);

    if (user != null) {
      setState(() {
        user_id = user['user_id'];
        company_id = user['company_id'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Akun',
            style: TextStyle(
              color: ThemeColors().textWhite,
            ),
          ),
          backgroundColor: ThemeColors().backgroundBlue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePasswordScreen()));
                  },
                  child: Text('Ubah Password'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors().backgroundBlue,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    logout();
                  },
                  child: _isLoading
                      ? SizedBox(
                          child: CircularProgressIndicator(
                            color: ThemeColors().textWhite,
                          ),
                          height: 18,
                          width: 18,
                        )
                      : Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors().backgroundBlue,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void logout() async {
    var data = {'user_id': user_id, 'company_id': company_id};
    var res = await Network().postData(data, '/logout');
    var body = json.decode(res.body);
    if (body['message'] != null) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('data');
      localStorage.remove('token');
      localStorage.remove('index');
      localStorage.remove('start_date');
      localStorage.remove('end_date');
      Navigator.pushReplacement(
          this.context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}
