import 'package:flutter/material.dart';

class RegisPasswordPage extends StatelessWidget {
  static const routeName = '/regisPassword';

  const RegisPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String noTelepon =
        ModalRoute.of(context)?.settings.arguments
            as String; // get arguments dari halaman sebelumnya

    return Scaffold(
      appBar: AppBar(title: const Text('Regis Password Page')),
      body: Center(child: Text('Regis Password Page $noTelepon')),
    );
  }
}
