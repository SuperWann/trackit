import 'package:flutter/material.dart';
import 'package:trackit_dev/widgets/input_form.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _noTeleponController = TextEditingController();

  @override
  void dispose() {
    _noTeleponController.dispose();
    super.dispose();
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
              child: Image.asset('assets/images/login_img.png'),
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

                      SizedBox(width: 10),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0D47A1), // biru
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(70, 50),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {},
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

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

                  const SizedBox(height: 20),

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
                      onPressed: () {},
                      child: const Text(
                        'Kamu seorang pegawai?',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
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
