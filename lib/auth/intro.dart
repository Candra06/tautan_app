import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intro_slider/slide_object.dart';

import 'package:intro_slider/intro_slider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tautan_app/auth/login.dart';
import 'package:tautan_app/helper/config.dart';
import 'package:tautan_app/helper/style.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SliderIntro(),
  ));
}

class SliderIntro extends StatefulWidget {
  @override
  _SliderIntroState createState() => _SliderIntroState();
}

class _SliderIntroState extends State<SliderIntro> {
  List<Slide> slides = new List();

  Function goToTap;

  @override
  void initState() {
    super.initState();
    slides.add(
      new Slide(
        title: "Menjelajah Dengan Aman",
        styleTitle: kTitleStyle,
        description: "Mencegah anda mengakses link hoax dan penipuan.",
        marginDescription: EdgeInsets.all(20),
        styleDescription: kSubtitleStyle,
        pathImage: "assets/images/boarding1.png",
      ),
    );
    slides.add(
      new Slide(
        title: "Periksa Link",
        styleTitle: kTitleStyle,
        description: "Pastikan status keamanan link yang akan anda buka.",
        styleDescription: kSubtitleStyle,
        pathImage: "assets/images/boarding2.png",
      ),
    );
    slides.add(
      new Slide(
        title: "Laporkan Link",
        styleTitle: kTitleStyle,
        description:
            "Bantu cegah penyebaran link hoax dan penipuan yang anda temukan.",
        styleDescription: kSubtitleStyle,
        pathImage: "assets/images/boarding3.png",
      ),
    );
  }

  void onDonePress() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("key", 1);
    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.upToDown,
            duration: Duration(seconds: 1),
            child: LoginPage()));
  }

  void onTabChangeComplete(index) {}

  Widget renderNextBtn() {
    return Text(
      'Lanjut',
      style: TextStyle(color: Colors.white, fontSize: 15),
    );
  }

  Widget renderBtnDone() {
    return Text(
      'Selesai',
      style: TextStyle(color: Colors.white, fontSize: 15),
    );
  }

  Widget renderSkipButton() {
    return Text(
      'Lewati',
      style: TextStyle(color: Colors.white, fontSize: 15),
    );
  }

  List<Widget> renderListCustomTab() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 32,
                  bottom: 32,
                ),
                margin: i == 0
                    ? EdgeInsets.only(left: 40)
                    : i == 2
                        ? EdgeInsets.only(right: 40)
                        : EdgeInsets.only(left: 0, right: 0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: i == 0
                        ? BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100))
                        : i == 2
                            ? BorderRadius.only(
                                topRight: Radius.circular(100),
                                bottomRight: Radius.circular(100))
                            : BorderRadius.all(
                                Radius.circular(0),
                              ),
                    color: Config.boxBlue),
                child: GestureDetector(
                    child: Image.asset(
                  currentSlide.pathImage,
                  width: 150.0,
                  height: 150.0,
                  fit: BoxFit.contain,
                )),
              ),
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: IntroSlider(
          // List slides
          slides: this.slides,

          // Skip button
          renderSkipBtn: this.renderSkipButton(),
          colorSkipBtn: Config.primary,
          highlightColorSkipBtn: Colors.white,

          // Next button
          renderNextBtn: this.renderNextBtn(),

          // Done button
          renderDoneBtn: this.renderBtnDone(),
          onDonePress: this.onDonePress,
          colorDoneBtn: Config.primary,
          highlightColorDoneBtn: Colors.white,

          // Dot indicator
          colorDot: Colors.black45,
          colorActiveDot: Config.primary,
          sizeDot: 8.0,

          // Tabs
          listCustomTabs: this.renderListCustomTab(),
          backgroundColorAllSlides: Colors.white,
          refFuncGoToTab: (refFunc) {
            this.goToTap = refFunc;
          },

          // Show or hide status bar
          shouldHideStatusBar: false,

          // On tab change completed
          onTabChangeCompleted: this.onTabChangeComplete,
        )),
      ),
    );
  }
}
