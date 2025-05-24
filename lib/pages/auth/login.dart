import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/widgets/dialog.dart';
import 'package:trackit_dev/widgets/inputForm.dart';

class LoginCustomerPage extends StatefulWidget {
  static const routeName = '/login';

  const LoginCustomerPage({super.key});

  @override
  State<LoginCustomerPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginCustomerPage> {
  final TextEditingController _noTeleponController = TextEditingController();

  @override
  void dispose() {
    _noTeleponController.dispose();
    super.dispose();
  }

  void _checkUserByTelepon() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final noTelepon = _noTeleponController.text;

    showDialog(
      context: context,
      barrierDismissible: false, // Tidak bisa ditutup klik di luar
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await provider.checkUserByTelepon(_noTeleponController.text);

      Navigator.pop(context);

      Navigator.pushNamed(
        context,
        provider.customerExist ? '/loginPassword' : '/regisPassword',
        arguments: noTelepon,
      );

      _noTeleponController.clear();
    } catch (e) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Trackit!',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent, // deteksi klik di area kosong
        onTap: () {
          FocusScope.of(context).unfocus(); // menyembunyikan keyboard
        },

        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Image.asset('assets/images/img_1.jpg', fit: BoxFit.cover),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // controller no telepon
                  Row(
                    children: [
                      Expanded(
                        child: InputFormWithHintText(
                          text: 'Nomor Telepon',
                          type: TextInputType.number,
                          controller: _noTeleponController,
                        ),
                      ),

                      SizedBox(width: 5),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0D47A1), // biru
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(70, 50),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (_noTeleponController.text.isEmpty) {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => YesDialog(
                                    title: 'Gagal',
                                    content:
                                        'Nomor telepon tidak boleh kosong!',
                                    onYes: () => Navigator.pop(context),
                                  ),
                            );
                          } else if (_noTeleponController.text.length < 10 ||
                              _noTeleponController.text.length > 13) {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => YesDialog(
                                    title: 'Gagal',
                                    content: 'Nomor telepon tidak valid!',
                                    onYes: () => Navigator.pop(context),
                                  ),
                            );
                          } else {
                            _checkUserByTelepon();
                          }
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                  const Center(
                    child: Text(
                      'Lainnya',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                  // Tombol Google
                  OutlinedButton.icon(
                    onPressed: () {},

                    icon: Image.asset(
                      'assets/images/google.png',
                      height: 24,
                      width: 24,
                    ),
                    label: const Text(
                      'Masuk dengan Google',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 92,
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                  // Syarat dan kebijakan
                  Text.rich(
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                    ),
                    TextSpan(
                      text: 'Login berarti anda setuju dengan kami\n',
                      style: TextStyle(color: Colors.black45, fontSize: 13),
                      children: [
                        TextSpan(
                          text: 'syarat layanan',
                          style: TextStyle(
                            color: Color(0xFF0D47A1),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ' dan '),
                        TextSpan(
                          text: 'kebijakan privasi',
                          style: TextStyle(
                            color: Color(0xFF0D47A1),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/loginPegawai');
                      },
                      child: const Text(
                        'Kamu seorang pegawai?',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
