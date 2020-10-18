import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tautan_app/helper/config.dart';
import 'package:tautan_app/helper/drawer.dart';
import 'package:tautan_app/helper/input.dart';
import 'package:tautan_app/helper/routes.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtPassword = new TextEditingController();
  TextEditingController txtNama = new TextEditingController();
  TextEditingController txtNIK = new TextEditingController();
  TextEditingController txtRePassword = new TextEditingController();
  bool show = true;
  String idGuest;
  void _toggleVisibility() {
    setState(() {
      show = !show;
    });
  }

  void getInfo() async {
    String nama = await Config.getNama(),
        email = await Config.getEmail(),
        nik = await Config.getNik(),
        id = await Config.getID();
    setState(() {
      txtEmail.text = email;
      txtNama.text = nama;
      txtNIK.text = nik;
      idGuest = id;
    });
  }

  void updateProfil() async {
    Config.loading(context);
    String token = await Config.getToken();
    var body = new Map<String, dynamic>();
    body['name'] = txtNama.text;
    body['nik'] = txtNIK.text;
    body['email'] = txtEmail.text;
    body['password'] = txtRePassword.text;

    http.Response up = await http.post(Config.ipServerAPI + 'updateProfil/$idGuest',
        body: body, headers: {'Authorization': 'Bearer ' + token});
    print(up.body);
    if (up.statusCode == 200) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('token', token);
      await pref.setString('nama', txtNama.text);
      await pref.setString('email', txtEmail.text);
      await pref.setString('nik', txtNIK.text);
      Navigator.pop(context);
      Config.alert(1, 'Berhasil mengubah data');
      Navigator.pushNamed(context, Routes.HOMEPAGE);
    } else {
      Navigator.pop(context);
      Config.alert(2, 'Gagal mengubah data');
    }
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      backgroundColor: Config.textWhite,
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Config.primary),
        title: new Text(
          "Profil",
          style: TextStyle(color: Config.primary),
        ),
        backgroundColor: Config.textWhite,
      ),
      body: Material(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(32, 32, 32, 8),
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
                      updateProfil();
                    },
                    child: Text(
                      'edit profil'.toUpperCase(),
                      style: TextStyle(
                          color: Config.textWhite,
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
}
