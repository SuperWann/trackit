import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/pages/auth/customer/login.dart';
import 'package:trackit_dev/pages/auth/customer/loginPassword.dart';
import 'package:trackit_dev/pages/auth/customer/regisPassword.dart';
import 'package:trackit_dev/pages/customer/beranda.dart';
import 'package:trackit_dev/pages/splash/splashScreen.dart';
import 'package:trackit_dev/providers/authProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splashscreen(),
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        LoginPasswordPage.routeName: (context) => LoginPasswordPage(),
        RegisPasswordPage.routeName: (context) => RegisPasswordPage(),
        BerandaPage.routeName: (context) => BerandaPage(),
      },
    );
  }
}
