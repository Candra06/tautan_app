import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tautan_app/auth/login.dart';
import 'package:tautan_app/helper/config.dart';
import 'package:tautan_app/helper/routes.dart';
import 'package:tautan_app/home/home.dart';
import 'package:tautan_app/home/profile.dart';
import 'package:tautan_app/laporan/addLaporan.dart';
import 'package:tautan_app/laporan/listLaporan.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String nama;
  void getInfo() async {
    String nm = await Config.getNama();
    setState(() {
      nama = nm;
    });
  }

  void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', '');
    Navigator.pushNamed(context, Routes.LOGIN);
    Config.alert(1, 'Berhasil LogOut');
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            child: DrawerHeader(
              child: Container(
                margin: EdgeInsets.only(top: 50),
                height: 100,
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/Logo.png',
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      nama == null ? '' : nama,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/BackImage.png'))),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Beranda',
                style: TextStyle(
                    color: Colors.black45, fontFamily: 'RobotoRegular')),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: HomePage(), type: PageTransitionType.fade));
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Buat Laporan',
                style: TextStyle(
                    color: Colors.black45, fontFamily: 'RobotoRegular')),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: AddLaporan(), type: PageTransitionType.fade));
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Riwayat Laporan',
                style: TextStyle(
                    color: Colors.black45, fontFamily: 'RobotoRegular')),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: RiwayatLaporan(), type: PageTransitionType.fade));
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Profil',
                style: TextStyle(
                    color: Colors.black45, fontFamily: 'RobotoRegular')),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: ProfilePage(), type: PageTransitionType.fade));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout',
                style: TextStyle(
                    color: Colors.black45, fontFamily: 'RobotoRegular')),
            onTap: () {
              logout();
            },
          ),
        ],
      ),
    );
  }
}

// class NavDrawer extends StatelessWidget {

// }
