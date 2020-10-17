import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tautan_app/auth/login.dart';
import 'package:tautan_app/auth/register.dart';
import 'package:tautan_app/auth/splash.dart';
import 'package:tautan_app/home/home.dart';
import 'package:tautan_app/laporan/addLaporan.dart';
import 'package:tautan_app/laporan/listLaporan.dart';

class Routes {
  static const String ROOT = '/';
  static const String SPLASHSCREEN = '/splash';
  static const String LOGIN = '/login';
  static const String HOMEPAGE = '/home';
  static const String REGISTER = '/register';
  static const String ADD_LAPORAN = '/add_laporan';
  static const String RIWAYAT_LAPORAN = '/riwayat_laporan';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ROOT:
        return null;
      case SPLASHSCREEN:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case LOGIN:
        return PageTransition(
            child: LoginPage(), type: PageTransitionType.fade);
      case REGISTER:
        return PageTransition(
            child: RegisterPage(), type: PageTransitionType.fade);
      case HOMEPAGE:
        return PageTransition(
            child: HomePage(), type: PageTransitionType.fade);
      case ADD_LAPORAN:
        return PageTransition(
            child: AddLaporan(), type: PageTransitionType.fade);
      case RIWAYAT_LAPORAN:
        return PageTransition(
            child: RiwayatLaporan(), type: PageTransitionType.fade);
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('Page ${settings.name} not defined'),
                  ),
                ));
    }
  }
}
