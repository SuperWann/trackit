import 'package:flutter/material.dart';
import 'package:trackit_dev/widgets/inputForm.dart';

class LacakResiCustomerPage extends StatefulWidget {
  static const routeName = '/lacakResiCustomer';

  const LacakResiCustomerPage({super.key});

  @override
  State<LacakResiCustomerPage> createState() => _LacakResiCustomerPageState();
}

class _LacakResiCustomerPageState extends State<LacakResiCustomerPage> {
  final TextEditingController _noResiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFECF0F1),
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
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Center(
                    child: Image.asset(
                      'assets/images/login_img.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'History Tracking Paket',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('- Paket diterima di gudang'),
                        Text('- Paket dalam perjalanan'),
                        Text('- Paket akan dikirim hari ini'),
                        SizedBox(
                          height: 400,
                        ), // contoh isi panjang supaya scroll bisa diuji
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: InputFormWithHintText(
                        type: TextInputType.text,
                        text: 'Masukkan Nomor Resi',
                        controller: _noResiController,
                      ),
                    ),
                    const SizedBox(width: 8),
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
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
