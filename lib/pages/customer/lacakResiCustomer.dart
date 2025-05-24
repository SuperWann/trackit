import 'package:flutter/material.dart';

class LacakResiCustomerPage extends StatefulWidget {
  static const routeName = '/lacakResiCustomer';

  const LacakResiCustomerPage({super.key});

  @override
  State<LacakResiCustomerPage> createState() => _LacakResiCustomerPageState();
}

class _LacakResiCustomerPageState extends State<LacakResiCustomerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('Lacak Resi Customer Page')),
    );
  }
}
