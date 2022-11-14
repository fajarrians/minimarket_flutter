import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:minimarket/layouts/bottomNav.dart';
import 'package:minimarket/network/api.dart';
import 'package:minimarket/theme/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _secureText = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var username;
  var password;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    ScaffoldMessenger.of(this.context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeColors().blue1,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo09.png',
                  height: 70,
                  width: 70,
                ),
                Text(
                  'Minimarket',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 34,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Login',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 28,
              ),
            ),
            Text(
              'Silakan login untuk masuk aplikasi.',
              style: TextStyle(
                color: ThemeColors().textGrey,
                fontSize: 12,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: 'Masukkan username',
                    ),
                    validator: (usernameValue) {
                      if (usernameValue!.isEmpty) {
                        return 'Username tidak boleh kosong!';
                      }
                      username = usernameValue;
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: _secureText,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Masukkan password',
                        suffixIcon: IconButton(
                          onPressed: showHide,
                          icon: Icon(_secureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                        )),
                    validator: (passwordValue) {
                      if (passwordValue!.isEmpty) {
                        return 'Passsword tidak boleh kosong!';
                      }
                      password = passwordValue;
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _login();
                        }
                      },
                      child: _isLoading
                          ? SizedBox(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                              height: 18,
                              width: 18,
                            )
                          : Text('Login'),
                      // child: Text(
                      //   _isLoading ? 'Proccessing..' : 'Login',
                      // ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors().blue4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    var data = {'username': username, 'password': password};

    var res = await Network().postData(data, '/login');
    var body = json.decode(res.body);
    if (body['data'] != null) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('data', json.encode(body['data']));
      Navigator.push(
        this.context,
        new MaterialPageRoute(builder: (context) => BottomNav()),
      );
    } else {
      _showMsg(body['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
