import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:trackit_dev/models/registrasiCustomer.dart';

class KonfirmasiPasswordPage extends StatelessWidget {
  static const routeName = '/konfirmPasswordPage';

  const KonfirmasiPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as RegistrasiCustomer;

    return Scaffold(
      appBar: AppBar(),
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
                "Konfirmasi PIN",
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "Masukkan PIN sebanyak 6 digit yang telah Anda buat!",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
              PinCodeFields(
                onComplete: (inputPin) {
                  inputPin == args.pin
                      ? Navigator.pushNamed(
                        context,
                        '/regisDataCustomerPage',
                        arguments: RegistrasiCustomer(
                          telepon: args.telepon,
                          pin: inputPin,
                        ),
                      )
                      : ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('PIN Salah!'),
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
