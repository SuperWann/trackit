import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/widgets/button.dart';
import 'package:trackit_dev/widgets/dialog.dart';
import 'package:trackit_dev/widgets/inputForm.dart';
import 'package:jwt_decode/jwt_decode.dart';

class LoginPegawaiPage extends StatefulWidget {
  static const routeName = '/loginPegawai';

  const LoginPegawaiPage({super.key});

  @override
  State<LoginPegawaiPage> createState() => _LoginPegawaiPageState();
}

class _LoginPegawaiPageState extends State<LoginPegawaiPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _loginPegawai(String email, String password) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    String? getPegawaiRole(String token) {
      final payload = Jwt.parseJwt(token);
      return payload['role'];
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Tidak bisa ditutup klik di luar
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await provider.getDataLoginPegawai(email, password);
      Navigator.pop(context);

      final data = provider.dataPegawai;
      if (data != null) {
        final pegawaiRole = getPegawaiRole(data.token);

        if (pegawaiRole == 'admin') {
          Navigator.pushReplacementNamed(context, '/berandaAdmin');
        } else if (pegawaiRole == 'kurir') {
          Navigator.pushReplacementNamed(context, '/berandaKurir');
        }
      } else {
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
      // Navigator.pushReplacementNamed(context, '/berandaPegawai');
    } catch (e) {
      Navigator.pop(context);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Image.asset(
                        'assets/images/logo_trackit_hitam.png',
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Email',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        InputFormWithHintText(
                          type: TextInputType.emailAddress,
                          text: 'Masukkan email',
                          controller: _emailController,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Text(
                            'Password',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        InputPassword(controller: _passwordController),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Lupa Password?',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F3A93),
                        ),
                      ),
                    ),
                    const Spacer(),
                    LongButton(
                      text: 'Masuk',
                      color: '#1F3A93',
                      colorText: '#FFFFFF',
                      onPressed: () {
                        _loginPegawai(
                          _emailController.text,
                          _passwordController.text,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
