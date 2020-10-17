import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tautan_app/helper/hexColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class Config {
  static final HexColor primary = new HexColor('#2966b2');
  static final HexColor darkPrimary = new HexColor('#2A3763');
  static final HexColor textWhite = new HexColor('#ffffff');
  static final HexColor textAuth = new HexColor('#407a9d');
  static final HexColor textMerah = new HexColor('#e82b3f');
  static final HexColor textGrey = new HexColor('#b7b8bc');
  static final HexColor textBlack = new HexColor('#000000');
  static final HexColor boxGreen = new HexColor('#e7f9f2');
  static final HexColor boxRed = new HexColor('#fbedee');
  static final HexColor boxBlue = new HexColor('#eceff1');
  static final HexColor onprogres = new HexColor('#008EE5');
  static final HexColor closed = new HexColor('#B3B3B3');
  static final HexColor open = new HexColor('#00C45C');

  static final String ipServer = 'http://kamper.evoindo.com/';
  static final String ipServerAPI = ipServer + 'api/';
  static final String ipAssets = '';

  static loading(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              // backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                  height: 200.0,
                  width: 200.0,
                  padding: EdgeInsets.all(18),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SpinKitHourGlass(color: Config.primary, size: 50.0),
                      SizedBox(height: 30.0),
                      Text(
                        "Memuat Data",
                        style: TextStyle(fontSize: 18, fontFamily: 'Airbnb'),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )));
        });
  }


  static alert(tipe, pesan) {
    Fluttertoast.showToast(
        msg: pesan,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: (tipe == 1 ? Colors.green : Colors.red),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static newloader(pesan) {
    return Center(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitHourGlass(color: Config.primary, size: 50.0),
          new Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: new Text(
                pesan,
                style: new TextStyle(color: Colors.black54, fontSize: 16.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  static formattanggal(tgl) {
    try {
      DateTime dt = DateTime.parse(tgl);
      var bln = [
        '',
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember'
      ];
      var newDt = DateFormat.EEEE().format(dt);
      var bulan = tgl.toString().split('-');
      print(newDt + ', ' + bln[int.parse(bulan[1])] + ' ' + bulan[0]);
      String tanggal = newDt + ', ' + bln[int.parse(bulan[1])] + ' ' + bulan[0];
      return tanggal;
    } catch (e) {
      return tgl.toString();
    }
  }

  static getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('token');
    return token;
  }

  static getNama() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String nama = preferences.getString('nama');
    return nama;
  }

  static getID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    return id;
  }

  static getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String email = preferences.getString('email');
    return email;
  }

  static getNik() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String nik = preferences.getString('nik');
    return nik;
  }
}


