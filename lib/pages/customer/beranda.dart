import 'package:flutter/material.dart';

class BerandaPage extends StatefulWidget {
  static const String routeName = '/berandaCustomer';

  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Beranda Page')));
  }
}
