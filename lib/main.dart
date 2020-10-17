import 'package:tautan_app/helper/appConfig.dart';
import 'package:tautan_app/helper/config.dart';
import 'package:tautan_app/helper/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  MyApp.initSystemDefault();

  runApp(AppConfig(
      appName: "Tautan Dev",
      flavorName: "dev",
      initialRoute: Routes.SPLASHSCREEN,
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var initialRoute = AppConfig.of(context).initialRoute;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: initialRoute,
      title: 'Tautan App',
    );
  }

  static void initSystemDefault() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Config.primary,
      ),
    );
  }
}
