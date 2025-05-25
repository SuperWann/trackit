import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/providers/otherProvider.dart';
import 'package:trackit_dev/widgets/button.dart';
import 'package:trackit_dev/widgets/inputForm.dart';

class DataPengirimPage extends StatefulWidget {
  Map<String, dynamic> dataPengirim = {};

  DataPengirimPage({super.key, required this.dataPengirim});

  @override
  State<DataPengirimPage> createState() => _DataPengirimPageState();
}

class _DataPengirimPageState extends State<DataPengirimPage> {
  List? dataKecamatan;
  int? selectedKecamatan;
  String? namaKecamatan;

  final TextEditingController _namaPengirimController = TextEditingController();
  final TextEditingController _teleponPengirimController =
      TextEditingController();
  final TextEditingController _detailPengirimController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    // Cek dan set data dari parameter jika tidak kosong
    if (widget.dataPengirim.isNotEmpty) {
      _namaPengirimController.text = widget.dataPengirim['nama_pengirim'] ?? '';
      _teleponPengirimController.text =
          widget.dataPengirim['telepon_pengirim'] ?? '';
      _detailPengirimController.text =
          widget.dataPengirim['detail_alamat_pengirim'] ?? '';
      selectedKecamatan = widget.dataPengirim['id_kecamatan'];
      namaKecamatan = widget.dataPengirim['nama_kecamatan'];
    }

    _namaPengirimController.addListener(() => setState(() {}));
    _teleponPengirimController.addListener(() => setState(() {}));
    _detailPengirimController.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final otherProvider = Provider.of<OtherProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      showDialog(
        context: context,
        barrierDismissible: false, // Tidak bisa ditutup klik di luar
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        if (dataKecamatan == null) {
          await otherProvider.getAllKecamatan(
            authProvider.dataCustomer!.kabupaten,
          ); //await memastikan kamu benar-benar menunggu proses ambil data selesai.
          Navigator.pop(context);
        }
      } catch (e) {
        Navigator.pop(context);
        print(e);
      }

      setState(() {
        dataKecamatan = otherProvider.dataKecamatan;
      });
      print(dataKecamatan);
    });
  }

  bool isComplete() {
    return _namaPengirimController.text.isNotEmpty &&
        _teleponPengirimController.text.isNotEmpty &&
        _detailPengirimController.text.isNotEmpty &&
        selectedKecamatan != null &&
        _teleponPengirimController.text.length >= 10;
  }

  @override
  void dispose() {
    _namaPengirimController.dispose();
    _teleponPengirimController.dispose();
    _detailPengirimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECF0F1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Data Pengirim',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Informasi Pengirim",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Montserrat',
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Nama Penerima",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    InputFormWithHintText(
                      type: TextInputType.text,
                      text: 'Nama Pengirim',
                      controller: _namaPengirimController,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 15),
                      child: Text(
                        "Nomor Telepon",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    InputFormWithHintText(
                      type: TextInputType.number,
                      text: 'Nomor Telepon Pengirim',
                      controller: _teleponPengirimController,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 15),
                      child: Text(
                        "Kecamatan",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color:
                            Colors
                                .grey[200], // Ganti dengan warna yang kamu mau
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<int>(
                        isExpanded: true,
                        underline: SizedBox(), // Menghilangkan garis bawah
                        value: selectedKecamatan,
                        hint: const Text(
                          'Pilih kecamatan',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        items:
                            dataKecamatan == null
                                ? []
                                : dataKecamatan!.map((item) {
                                  return DropdownMenuItem<int>(
                                    value: item['id_kecamatan'],
                                    child: Text(
                                      item['nama_kecamatan'],
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedKecamatan = value;
                            namaKecamatan =
                                dataKecamatan!.firstWhere(
                                  (item) => item['id_kecamatan'] == value,
                                )['nama_kecamatan'];
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 15),
                      child: Text(
                        "Detail Alamat",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    InputFormWithHintText(
                      type: TextInputType.text,
                      text: 'Detail Alamat Pengirim',
                      controller: _detailPengirimController,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
            right: 20,
            left: 20,
            bottom: 20,
            top: 20,
          ),
          child: LongButton(
            text: "Simpan",
            color: isComplete() ? "#0D47A1" : "#C4C4C4",
            colorText: "#FFFFFF",
            onPressed:
                isComplete()
                    ? () {
                      Navigator.pop(context, {
                        'nama_pengirim': _namaPengirimController.text,
                        'telepon_pengirim': _teleponPengirimController.text,
                        'id_kecamatan': selectedKecamatan,
                        'nama_kecamatan': namaKecamatan,
                        'detail_alamat_pengirim':
                            _detailPengirimController.text,
                      });
                    }
                    : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Data belum lengkap!',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }, // Tombol tidak aktif kalau belum dicentang
          ),
        ),
      ),
    );
  }
}
