import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/pages/customer/detailOrder.dart';
import 'package:trackit_dev/pages/splash/splashScreen.dart';
import 'package:trackit_dev/pages/admin/berandaAdmin.dart';
import 'package:trackit_dev/pages/auth/login.dart';
import 'package:trackit_dev/pages/auth/customer/loginPassword.dart';
import 'package:trackit_dev/pages/auth/customer/regisPassword.dart';
import 'package:trackit_dev/pages/auth/pegawai/login.dart';
import 'package:trackit_dev/pages/customer/berandaCustomer.dart';
import 'package:trackit_dev/pages/customer/lacakResiCustomer.dart';
import 'package:trackit_dev/pages/customer/navbarCustomer.dart';
import 'package:trackit_dev/pages/customer/orderFormCustomer.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/providers/customerProvider.dart';
import 'package:trackit_dev/providers/otherProvider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final provider = AuthProvider();
  provider.checkLoginStatus();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OtherProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
      ],
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
        //CUSTOMER
        NavbarCustomer.routeName: (context) => NavbarCustomer(),
        BerandaCustomerPage.routeName: (context) => BerandaCustomerPage(),
        LoginCustomerPage.routeName: (context) => LoginCustomerPage(),
        LoginPasswordPage.routeName: (context) => LoginPasswordPage(),
        RegisPasswordPage.routeName: (context) => RegisPasswordPage(),
        OrderCustomerFormPage.routeName: (context) => OrderCustomerFormPage(),
        LacakResiCustomerPage.routeName: (context) => LacakResiCustomerPage(),
        DetailOrderPage.routeName: (context) => DetailOrderPage(),

        //PEGAWAI
        BerandaAdminPage.routeName: (context) => BerandaAdminPage(),
        LoginPegawaiPage.routeName: (context) => LoginPegawaiPage(),
      },
    );
  }
}
