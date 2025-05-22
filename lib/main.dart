import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/pages/admin/berandaAdmin.dart';
import 'package:trackit_dev/pages/auth/customer/login.dart';
import 'package:trackit_dev/pages/auth/customer/loginPassword.dart';
import 'package:trackit_dev/pages/auth/customer/regisPassword.dart';
import 'package:trackit_dev/pages/auth/pegawai/login.dart';
import 'package:trackit_dev/pages/customer/berandaCustomer.dart';
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
        BerandaAdminPage.routeName: (context) => BerandaAdminPage(),
        LoginPegawaiPage.routeName: (context) => LoginPegawaiPage(),
        LoginCustomerPage.routeName: (context) => LoginCustomerPage(),
        LoginPasswordPage.routeName: (context) => LoginPasswordPage(),
        RegisPasswordPage.routeName: (context) => RegisPasswordPage(),
        BerandaCustomerPage.routeName: (context) => BerandaCustomerPage(),
      },
    );
  }
}
