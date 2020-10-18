import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tautan_app/auth/login.dart';
import 'package:tautan_app/helper/config.dart';
import 'package:tautan_app/helper/drawer.dart';
import 'package:tautan_app/helper/routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;
// import 'package:uni_links/uni_links.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController txtCari = new TextEditingController();
  bool loadPage = false;
  bool show = false;
  String status = '', kategori = '', diperiksa = '', link = '', statusLink = '';

  Future<Null> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      String initialLink = await getInitialLink();
      print(initialLink);
      txtCari.text = initialLink;
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }

  void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // await pref.clear();
    await pref.remove('token');
    String token = await Config.getToken();
    print(token);
    Navigator.pushReplacement(context,
        PageTransition(child: LoginPage(), type: PageTransitionType.downToUp));
    Config.alert(1, 'Berhasil LogOut');
  }

  @override
  void initState() {
    initUniLinks();
    super.initState();
  }

  void dialogLogout() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Apakah Anda Yakin?'),
        content: new Text('Ingin Keluar Dari Akun ini?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'Tidak',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Config.primary),
            ),
          ),
          new FlatButton(
            onPressed: () => logout(),
            child: new Text(
              'Ya',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Config.primary),
            ),
          ),
        ],
      ),
    );
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

  void cekLink() async {
    Config.loading(context);
    String token = await Config.getToken();
    var body = new Map<String, dynamic>();
    body['cari'] = txtCari.text;
    http.Response res = await http.post(Config.ipServerAPI + 'search',
        body: body, headers: {'Authorization': 'Bearer ' + token});
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      if (data['value'] == '1' && data['data'] != null) {
        setState(() {
          status = 'available';
          statusLink = data['value'] ;
          kategori = data['data']['kategori'].toString().toUpperCase();
          diperiksa = data['data']['diperiksa'].toString();
          link = 'http://' + data['data']['link'].toString();
          Navigator.pop(context);
          alert(context);
        });
      } else if (data['value'] == '0' && data['data'] != null) {
        setState(() {
          status = 'available';
          statusLink = data['value'] ;
          kategori = data['data']['kategori'].toString().toUpperCase();
          diperiksa = data['data']['diperiksa'].toString();
          link = 'http://' + data['data']['link'].toString();
          Navigator.pop(context);
          alertAman(context);
        });
      } else {
        setState(() {
          status = 'notavailable';
          kategori = '-';
          diperiksa = '0';
          link = 'http://' + txtCari.text;
          Navigator.pop(context);
          nothing(context);
        });
      }
    } else {
      Navigator.pop(context);
    }
  }

  alertAman(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Link Aman'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Link tidak mengandung unsur hoax atau penipuan.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  show = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  alert(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Link Berbahaya'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Mengandung unsur hoax atau penipuan.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  show = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  nothing(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Link Tidak Terdeteksi'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Link kemungkinan aman atau belum teridentifikasi.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('LAPORKAN LINK'),
              onPressed: () {
                Navigator.pushNamed(context, Routes.ADD_LAPORAN);
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  show = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: NavDrawer(),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: new AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () {
                dialogLogout();
              },
            )
          ],
          title: new Text(
            " ",
            style: TextStyle(color: Colors.amber),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body:
            //     StreamBuilder(
            //       stream: getLinksStream(),
            //       builder: (context , snapshot){
            //  if( snapshot.hasData ) { // our app started by configured links
            //   var uri = Uri.parse(snapshot.data);
            //   var list =uri.queryParametersAll.entries.toList(); // we retrieve all query parameters , tzd://genius-team.com?product_id=1

            //   return Text(list.map((f)=>f.toString()).join('-'));
            //    // we just print all //parameters but you can now do whatever you want, for example open //product details page.
            //   }else { // our app started normally
            //     return HomePage();
            //   }
            // } ,
            Stack(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  'assets/images/Background.png',
                  fit: BoxFit.fill,
                )),
            Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            'Periksa Link',
                            style: TextStyle(
                                fontFamily: 'RobotoMedium',
                                fontSize: 20,
                                color: Config.textWhite),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(
                            'Periksa keamanan link yang anda buka',
                            style: TextStyle(
                                fontFamily: 'RobotoLight',
                                fontSize: 16,
                                color: Config.textWhite),
                          ),
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: TextField(
                              controller: txtCari,
                              decoration: new InputDecoration(
                                  suffixIcon: Container(
                                      padding: EdgeInsets.all(0),
                                      margin: EdgeInsets.all(4),
                                      width: 40,
                                      // width: 35,
                                      // height: 35,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Config.primary),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.search,
                                          color: Config.textWhite,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            cekLink();
                                          });
                                        },
                                      )),
                                  contentPadding: EdgeInsets.only(
                                      left: 16, right: 16, top: 0),
                                  border: new OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle:
                                      new TextStyle(color: Colors.black38),
                                  hintText: "Type in your text",
                                  fillColor: Colors.white70),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
                            child: FlatButton(
                              onPressed: () {
                                FlutterClipboard.paste().then((value) {
                                  setState(() {
                                    txtCari.text = value;
                                  });
                                });
                                // alert(context);
                              },
                              child: Text(
                                'Tempel Link'.toUpperCase(),
                                style: TextStyle(
                                    color: Config.primary,
                                    fontSize: 16,
                                    fontFamily: 'RobotoMedium'),
                              ),
                            )),
                        Visibility(
                          visible: show,
                          child: Container(
                            margin: EdgeInsets.all(16),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Config.textWhite,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.search,
                                        size: 13,
                                        color: Config.textGrey,
                                      ),
                                      Text(' 19/08/2020 20:20',
                                          style: TextStyle(
                                              color: Config.textGrey,
                                              fontSize: 13,
                                              fontFamily: 'RobotoLight')),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Keamanan situs dapat berubah sewaktu-waktu. Periksa kembali untuk melihat update.',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: 'RobotoLight'),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('Status'),
                                        Text('Kategori'),
                                        Text('Diperiksa'),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(' : '),
                                        Text(' : '),
                                        Text(' : '),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          status == 'available' && statusLink == '1' 
                                              ? ' Link Berbahaya'
                                              : status == 'available' && statusLink == '0' ? 'Link Aman' :' Link Tidak Terdeteksi ',
                                          style: TextStyle(
                                              color: status == 'available' && statusLink == '1' 
                                                  ? Colors.red
                                                   : status == 'available' && statusLink == '0'  ? Colors.green : Colors.green ),
                                        ),
                                        Text(status == 'available'
                                            ? ' Di laporkan sebagai $kategori '
                                            : ' - '),
                                        Text(status == 'available'
                                            ? ' $diperiksa kali'
                                            : ' - '),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      launch("$link");
                                    },
                                    child: Text(
                                      '$link',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
