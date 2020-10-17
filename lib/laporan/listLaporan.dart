import 'package:flutter/material.dart';
import 'package:tautan_app/helper/config.dart';
import 'package:tautan_app/helper/drawer.dart';
import 'package:tautan_app/helper/routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RiwayatLaporan extends StatefulWidget {
  @override
  _RiwayatLaporanState createState() => _RiwayatLaporanState();
}

class _RiwayatLaporanState extends State<RiwayatLaporan> {
  List riwayatLaporan = [];
  bool loadPage = false;

  Widget templateList(
      String tanggal, String kategoriI, String status, String link) {
    return Container(
      margin: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
          color: Config.textWhite,
          borderRadius: BorderRadius.all(Radius.circular(10))),
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
                Text(tanggal,
                    style: TextStyle(
                        color: Config.textGrey,
                        fontSize: 13,
                        fontFamily: 'RobotoLight')),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Kategori'),
                  Text('Status'),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(' : '),
                  Text(' : '),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' $kategoriI ',
                  ),
                  Text(
                    status == 'confirmed' ? ' Terverifikasi ' : ' Belum dikonfirmasi ',
                    style: TextStyle(
                        color: status == 'confirmed'
                            ? Colors.green
                            : Colors.red),
                  ),
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
    );
  }

  List kategori = ['Pilih kategori', 'hoax', 'penipuan'];
  String getKategori;
  List<DropdownMenuItem<String>> kategoriItem;

  List<DropdownMenuItem<String>> getDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (String ktg in kategori) {
      items.add(new DropdownMenuItem(value: ktg, child: new Text(ktg)));
    }
    return items;
  }

  void changedDropDownItem(String selectedKategori) {
    setState(() {
      getKategori = selectedKategori;
    });
  }

  void getData() async {
    setState(() {
      loadPage = true;
    });
    String token = await Config.getToken();
    String id = await Config.getID();
    print(Config.ipServerAPI + 'history/$id');
    http.Response res = await http.get(Config.ipServerAPI + 'history/$id',
        headers: {'Authorization': 'Bearer ' + token});
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      setState(() {
        riwayatLaporan = data['data'];
        loadPage = false;
      });
    } else {
      setState(() {
        loadPage = false;
        Config.alert(2, 'Gagal menampilkan data');
      });
    }
  }

  @override
  void initState() {
    kategoriItem = getDropDown();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context, Routes.HOMEPAGE);
      },
      child: Scaffold(
        drawer: NavDrawer(),
        backgroundColor: Config.textWhite,
        appBar: new AppBar(
          iconTheme: new IconThemeData(color: Config.primary),
          title: new Text(
            "Riwayat Laporan",
            style: TextStyle(color: Config.primary),
          ),
          backgroundColor: Config.textWhite,
        ),
        body: Stack(
          children: [
            Scaffold(
              body: new Container(
                  // color: Colors.red,
                  ),
            ),
            if (loadPage) ...{
              Config.newloader('Memuat data')
            } else if (riwayatLaporan.length == 0 ||
                riwayatLaporan == null) ...{
              Center(
                child: Container(
                  child: Text('Tidak ada riwayat laporan'),
                ),
              )
            } else ...{
              Container(
                  margin: EdgeInsets.all(16),
                  child: ListView.builder(
                      itemCount: riwayatLaporan.length == 0 || riwayatLaporan == null ? 0 : riwayatLaporan.length,
                      itemBuilder: (BuildContext context, int i) {
                        return templateList(
                            riwayatLaporan[i]['created_at'],
                            riwayatLaporan[i]['kategori'],
                            riwayatLaporan[i]['status'],
                            riwayatLaporan[i]['link']);
                      })),
            }
          ],
        ),
      ),
    );
  }
}
