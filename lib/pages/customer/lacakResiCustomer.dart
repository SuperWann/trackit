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
      backgroundColor: Color(0xFFECF0F1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Lacak Resi',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Center(child: Text('Lacak Resi Customer Page')),
    );
  }
}
