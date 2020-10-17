import 'package:flutter/material.dart';
import 'package:tautan_app/helper/config.dart';
import 'package:tautan_app/helper/input.dart';
// import 'package:tautan_app/helper/routes.dart';
import 'package:http/http.dart' as http;

import 'package:tautan_app/helper/routes.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtPassword = new TextEditingController();
  TextEditingController txtNama = new TextEditingController();
  TextEditingController txtNIK = new TextEditingController();
  TextEditingController txtRePassword = new TextEditingController();
  bool show = true;
  void _toggleVisibility() {
    setState(() {
      show = !show;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Daftar',
                  style: TextStyle(fontFamily: 'RobotoMedium', fontSize: 20),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(32, 0, 31, 8),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Buat akun baru.',
                  style: TextStyle(fontFamily: 'RobotoLight'),
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(32, 8, 32, 8),
                  child: inputText('Nama', TextInputType.text, txtNama)),
              Container(
                  margin: EdgeInsets.fromLTRB(32, 8, 32, 8),
                  child:
                      inputText('Email', TextInputType.emailAddress, txtEmail)),
              Container(
                  margin: EdgeInsets.fromLTRB(32, 8, 32, 8),
                  child: inputText(
                      'Nomor Induk Keluarga', TextInputType.text, txtNIK)),
              Container(
                  margin: EdgeInsets.fromLTRB(32, 8, 32, 8),
                  child: inputPassword(
                    'Kata Sandi',
                    txtPassword,
                    TextInputType.text,
                    'Kata Sandi',
                    show,
                    _toggleVisibility,
                  )),
              Container(
                  margin: EdgeInsets.fromLTRB(32, 8, 32, 8),
                  child: inputPassword(
                    'Ulangi Kata Sandi',
                    txtRePassword,
                    TextInputType.text,
                    'Ulangi Kata Sandi',
                    show,
                    _toggleVisibility,
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
                      color: Config.primary,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  margin: EdgeInsets.fromLTRB(32, 8, 32, 8),
                  child: FlatButton(
                    onPressed: () {
                      if (txtEmail.text == '' || txtEmail.text == null) {
                        Config.alert(2, 'Email tidak valid');
                      } else if (txtNama.text == '') {
                        Config.alert(2, 'Nama tidak valid');
                      } else if (txtNIK.text == '') {
                        Config.alert(2, 'NIK tidak valid');
                      } else if (txtPassword.text == '') {
                        Config.alert(2, 'Password tidak valid');
                      } else if (txtRePassword.text == '' ||
                          txtRePassword.text != txtPassword.text) {
                        Config.alert(2, 'Password tidak sesuai ');
                      } else {
                        register();
                      }
                    },
                    child: Text(
                      'buat akun'.toUpperCase(),
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
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Masuk'.toUpperCase(),
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
    );
  }

  void register() async {
    Config.loading(context);
    var body = new Map<String, dynamic>();
    body['name'] = txtNama.text;
    body['nik'] = txtNIK.text;
    body['email'] = txtEmail.text;
    body['password'] = txtPassword.text;
    body['role'] = 'guest';

    http.Response res = await http.post(Config.ipServerAPI + 'register', body: body);
    print(Config.ipServerAPI + 'register');
    if (res.statusCode == 200) {
      Navigator.pop(context);
      Config.alert(1, "Register Berhasil");
      setState(() {
        Navigator.pushNamed(context, Routes.LOGIN);
      });
    } else {
      print(res.body);
      Navigator.pop(context);
      Config.alert(2, "Register Gagal");
    }
  }
}
