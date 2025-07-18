import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:trackit_dev/models/registrasiCustomer.dart';

class RegisPasswordPage extends StatelessWidget {
  static const routeName = '/regisPassword';

  const RegisPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String noTelepon =
        ModalRoute.of(context)?.settings.arguments
            as String; // get arguments dari halaman sebelumnya

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Image.asset('assets/images/logo_trackit_hitam.png'),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                "Buat PIN",
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "Buat PIN sebanyak 6 digit untuk verifikasi login Anda!",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
              PinCodeFields(
                onComplete: (inputPin) {
                  Navigator.pushNamed(
                    context,
                    '/konfirmPasswordPage',
                    arguments: RegistrasiCustomer(
                      telepon: noTelepon,
                      pin: inputPin,
                    ),
                  );
                },
                autoHideKeyboard: false,
                length: 6,
                obscureText: true,
                fieldBorderStyle: FieldBorderStyle.square,
                fieldBackgroundColor: Color(0xFFD9D9D9),
                borderColor: Color(0xFFD9D9D9),
                fieldHeight: 50,
                keyboardType: TextInputType.number,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
