import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tautan_app/helper/config.dart';
import 'package:tautan_app/helper/input.dart';
import 'package:tautan_app/helper/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtPassword = new TextEditingController();
  bool show = true;
  void _toggleVisibility() {
    setState(() {
      show = !show;
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Apakah Anda Yakin?'),
            content: new Text('Ingin Keluar Dari Aplikasi'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'Tidak',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Config.primary),
                ),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text(
                  'Ya',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Config.primary),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Material(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Stack(
                    children: [
                      Container(
                        height: 225,
                      ),
                      Container(
                        height: 175,
                        color: Config.boxBlue,
                      ),
                      Image.asset(
                        'assets/images/BackImage.png',
                        height: 175,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                          bottom: 0,
                          left: MediaQuery.of(context).size.width * 1 / 3,
                          right: MediaQuery.of(context).size.width * 1 / 3,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            width: 40,
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/Logo.png',
                              width: 30,
                              height: 30,
                            ),
                          ))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(32, 16, 31, 8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Masuk',
                    style: TextStyle(fontFamily: 'RobotoMedium', fontSize: 20),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(32, 0, 31, 8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Silahkan masukkan Email dan Password untuk melanjutkan.',
                    style: TextStyle(fontFamily: 'RobotoLight'),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(32, 8, 32, 8),
                    child: inputText(
                        'Email', TextInputType.emailAddress, txtEmail)),
                Container(
                    margin: EdgeInsets.fromLTRB(32, 8, 32, 8),
                    child: inputPassword(
                      'Password',
                      txtPassword,
                      TextInputType.text,
                      'Password',
                      show,
                      _toggleVisibility,
                    )),
                // Container(
                //   alignment: Alignment.centerLeft,
                //   margin: EdgeInsets.fromLTRB(32, 8, 8, 8),
                //   child: InkWell(
                //     child: Text('Lupa kata sandi?'),
                //     onTap: () {},
                //   ),
                // ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                        color: Config.primary,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    margin: EdgeInsets.fromLTRB(32, 8, 32, 8),
                    child: FlatButton(
                      onPressed: () {
                        if (txtEmail.text == '') {
                          Config.alert(2, 'Email tidak boleh kosong');
                        } else if (txtPassword.text == '') {
                          Config.alert(2, 'Email tidak boleh kosong');
                        } else {
                          login();
                        }
                      },
                      child: Text(
                        'Masuk'.toUpperCase(),
                        style: TextStyle(
                            color: Config.textWhite,
                            fontSize: 16,
                            fontFamily: 'RobotoMedium'),
                      ),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                        color: Config.textWhite,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    margin: EdgeInsets.fromLTRB(32, 8, 32, 16),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.REGISTER);
                      },
                      child: Text(
                        'Buat Akun'.toUpperCase(),
                        style: TextStyle(
                            color: Config.primary,
                            fontSize: 16,
                            fontFamily: 'RobotoMedium'),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    Config.loading(context);
    var body = new Map<String, dynamic>();
    body['email'] = txtEmail.text;
    body['password'] = txtPassword.text;
    var res = await http.post(Config.ipServerAPI + 'login', body: body);
    print(Config.ipServerAPI + 'login');
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      String token = data['access_token'];
      var detail = await http.post(Config.ipServerAPI + 'details', headers: {
        'Authorization': 'Bearer ' + token,
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      });
      var getData = json.decode(detail.body);
      String nama = getData['data']['name'];
      String email = getData['data']['email'];
      String nik = getData['data']['nik'];
      int id = getData['data']['id'];

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('token', token);
      await pref.setString('nama', nama);
      await pref.setString('email', email);
      await pref.setString('nik', nik);
      await pref.setString('id', id.toString());
      Config.alert(1, 'Login berhasil');
      Navigator.pop(context);
      Navigator.pushNamed(context, Routes.HOMEPAGE);
    } else {
      Navigator.pop(context);
      Config.alert(2, 'Login gagal');
    }
  }
}
