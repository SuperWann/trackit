import 'package:flutter/material.dart';

class BerandaAdminPage extends StatefulWidget {
  static const String routeName = '/berandaAdmin';

  const BerandaAdminPage({super.key});

  @override
  State<BerandaAdminPage> createState() => _BerandaAdminPageState();
}

class _BerandaAdminPageState extends State<BerandaAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Beranda Admin Page')),
    );
  }
}