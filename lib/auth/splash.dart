import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tautan_app/auth/intro.dart';
import 'package:tautan_app/auth/login.dart';
// import 'package:page_transition/page_transition.dart';
import 'package:tautan_app/helper/config.dart';
import 'package:tautan_app/home/home.dart';
// import 'package:tautan_app/home/sharing.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

    _controller.forward();

    Future.delayed(Duration(seconds: 3), () async {
      SharedPreferences pref = await SharedPreferences.getInstance();

      String token = await Config.getToken();
      // print('token '+token);
      if (pref.getInt("key") == 1) {
        if (token == '' || token == null) {
          Navigator.of(context).pushReplacement(PageTransition(
              child: LoginPage(), type: PageTransitionType.fade));
        } else {
          Navigator.of(context).pushReplacement(
              PageTransition(child: HomePage(), type: PageTransitionType.fade));
        }
      } else {
        Navigator.of(context).pushReplacement(PageTransition(
            child: SliderIntro(), type: PageTransitionType.upToDown));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ScaleTransition(
          scale: _animation,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Logo.png',
                  width: 180,
                  height: 180,
                ),
                Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      'Tautan',
                      style: TextStyle(
                          color: Config.primary,
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'RobotoBold'),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
