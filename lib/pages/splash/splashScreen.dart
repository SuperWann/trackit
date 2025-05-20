import 'package:flutter/material.dart';

class Splashscreen extends StatelessWidget {
  static const routeName = '/splashscreen';

  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Image.asset('assets/images/logo_trackit.png'),
            ),
          ],
        ),
      ),

      backgroundColor: Color(0xFF1F3A93),
    );
  }
}
