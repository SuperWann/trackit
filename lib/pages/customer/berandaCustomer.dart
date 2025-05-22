import 'package:flutter/material.dart';

class BerandaCustomerPage extends StatefulWidget {
  static const routeName = '/berandaCustomer';

  const BerandaCustomerPage({super.key});

  @override
  State<BerandaCustomerPage> createState() => _BerandaCustomerPageState();
}

class _BerandaCustomerPageState extends State<BerandaCustomerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: const Text(
            'Trackit!',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_outlined),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset('assets/images/login_img.png'),
          ),
          Padding(padding: EdgeInsets.all(20), child: Column(children: [
            
          ],)),
        ],
      ),
    );
  }
}
