import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/widgets/dialog.dart';

class LoginPasswordPage extends StatefulWidget {
  static const routeName = '/loginPassword';

  const LoginPasswordPage({super.key});

  @override
  State<LoginPasswordPage> createState() => _LoginPasswordPageState();
}

class _LoginPasswordPageState extends State<LoginPasswordPage> {
  void _loginCustomer(String noTelepon, String pin) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await provider.getDataLoginCustomer(noTelepon, pin);

      Navigator.pop(context); // remove loading

      final data = provider.dataCustomer;

      if (data != null) {
        // Navigasi ke halaman utama jika login berhasil
        Navigator.pushNamed(context, '/berandaCustomer');
      } else {
        // Tampilkan pesan kesalahan jika login gagal
        showDialog(
          context: context,
          builder:
              (context) => YesDialog(
                title: 'Login Gagal',
                content: 'Password Salah',
                onYes: () => Navigator.pop(context),
              ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // remove loading
      // Tampilkan pesan kesalahan jika login gagal
      print('Login Gagal tampilkan dialog error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String noTelepon =
        ModalRoute.of(context)?.settings.arguments
            as String; // get arguments dari halaman sebelumnya

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
                child: Image.asset('assets/images/logo_trackit_hitam.png'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              PinCodeFields(
                onComplete: (inputPin) {
                  _loginCustomer(noTelepon, inputPin);
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
              TextButton(
                child: const Text(
                  'Lupa Password?',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F3A93),
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
