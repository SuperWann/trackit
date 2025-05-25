import 'package:flutter/material.dart';

class OrderCustomerPage extends StatelessWidget {
  const OrderCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [Text('1')]),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [Text('2')]),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [Text('3')]),
        ),
      ],
    );
  }
}
