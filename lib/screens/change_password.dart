import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:minimarket/layouts/bottomNav.dart';
import 'package:minimarket/network/api.dart';
import 'package:minimarket/theme/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isLoading = false;
  bool _secureTextOld = true;
  bool _secureTextNew = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController old_password = TextEditingController();
  TextEditingController new_password = TextEditingController();
  var passwordOld;
  var passwordNew;
  var user_id;

  @override
  void initState() {
    super.initState();
    _getDataUser();
  }

  _getDataUser() async {
    final localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('data')!);

    if (user != null) {
      setState(() {
        user_id = user['user_id'];
      });
    }
  }

  showHideOld() {
    setState(() {
      _secureTextOld = !_secureTextOld;
    });
  }

  showHideNew() {
    setState(() {
      _secureTextNew = !_secureTextNew;
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Ubah Password',
          style: TextStyle(
            color: ThemeColors().textWhite,
          ),
        ),
        backgroundColor: ThemeColors().backgroundBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeColors().backgroundWhite),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    obscureText: _secureTextOld,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: old_password,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password Lama',
                      hintText: 'Masukkan password lama',
                      suffixIcon: IconButton(
                        onPressed: showHideOld,
                        icon: Icon(_secureTextOld
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                    validator: (passwordOldValue) {
                      if (passwordOldValue!.isEmpty) {
                        return 'Username lama tidak boleh kosong!';
                      }
                      passwordOld = passwordOldValue;
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: _secureTextNew,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: new_password,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password Baru',
                      hintText: 'Masukkan password baru',
                      suffixIcon: IconButton(
                        onPressed: showHideNew,
                        icon: Icon(_secureTextNew
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                    validator: (passwordNewValue) {
                      if (passwordNewValue!.isEmpty) {
                        return 'Passsword baru tidak boleh kosong!';
                      }
                      passwordNew = passwordNewValue;
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
                          _changePassword();
                        }
                      },
                      child: _isLoading
                          ? SizedBox(
                              child: CircularProgressIndicator(
                                color: ThemeColors().textWhite,
                              ),
                              height: 18,
                              width: 18,
                            )
                          : Text(
                              'Simpan',
                              style: TextStyle(
                                color: ThemeColors().textWhite,
                              ),
                            ),
                      // child: Text(
                      //   _isLoading ? 'Proccessing..' : 'Login',
                      // ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors().backgroundBlue,
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

  void _changePassword() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'old_password': passwordOld,
      'new_password': passwordNew,
      'user_id': user_id
    };
    var res = await Network().postData(data, '/change-password-user');
    var body = json.decode(res.body);

    if (body['statusCode'] == 201) {
      Future.delayed(
          Duration(seconds: 2),
          () => [
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNav(),
                  ),
                ),
                _showMsg(body['message'])
              ]);
    } else {
      Future.delayed(
          Duration(seconds: 2),
          () => [
                _showMsg(body['message']),
                setState(() {
                  _isLoading = false;
                }),
                old_password.clear(),
                new_password.clear()
              ]);
    }
  }
}
