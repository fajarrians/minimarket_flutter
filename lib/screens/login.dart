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
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorPalette().white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: topClipper(),
              child: Container(
                height: 200,
                color: ColorPalette().purple,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Row(
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
                          color: ColorPalette().white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                        color: ColorPalette().black,
                      ),
                    ),
                    Text(
                      'Silakan login untuk masuk aplikasi.',
                      style: TextStyle(
                        color: ColorPalette().grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            autofocus: false,
                            decoration: InputDecoration(
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Icon(Icons.person_rounded),
                              ),
                              contentPadding: const EdgeInsets.fromLTRB(
                                  20.0, 15.0, 20.0, 15.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              hintText: 'Username',
                            ),
                            validator: (usernameValue) {
                              if (usernameValue!.isEmpty) {
                                return 'Username tidak boleh kosong!';
                              }
                              username = usernameValue;
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            obscureText: _secureText,
                            enableSuggestions: false,
                            autocorrect: false,
                            autofocus: false,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 15.0, 20.0, 15.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                hintText: 'Password',
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  child: Icon(Icons.lock_rounded),
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: IconButton(
                                    onPressed: showHide,
                                    icon: Icon(_secureText
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                )),
                            validator: (passwordValue) {
                              if (passwordValue!.isEmpty) {
                                return 'Passsword tidak boleh kosong!';
                              }
                              password = passwordValue;
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              boxShadow: [
                                const BoxShadow(
                                  color: Color.fromARGB(87, 0, 0, 0),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: Offset(2, 3),
                                )
                              ],
                              borderRadius: BorderRadius.circular(32),
                            ),
                            height: 40,
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _login();
                                }
                              },
                              child: _isLoading
                                  ? SizedBox(
                                      child: CircularProgressIndicator(
                                        color: ColorPalette().white,
                                      ),
                                      height: 18,
                                      width: 18,
                                    )
                                  : Text(
                                      'Login',
                                      style: TextStyle(
                                        color: ColorPalette().white,
                                      ),
                                    ),
                              // child: Text(
                              //   _isLoading ? 'Proccessing..' : 'Login',
                              // ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorPalette().purple,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
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
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),
      );
    } else {
      _showMsg(body['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }
}

class topClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double width = size.width;
    double height = size.height;
    double offset = 100.0;
    Path path = Path();
    path.lineTo(0, height - offset);
    path.quadraticBezierTo(width / 2, height, width, height - offset);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
