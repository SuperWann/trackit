import 'package:flutter/material.dart';
import 'package:trackit_dev/pages/auth/login.dart';
import 'package:trackit_dev/pages/splash/splashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splashscreen(),
      routes: {LoginPage.routeName: (context) => LoginPage()},
    );
  }
}
