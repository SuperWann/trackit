import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/providers/otherProvider.dart';
import 'package:trackit_dev/widgets/button.dart';
import 'package:trackit_dev/widgets/inputForm.dart';

class DataPenerimaPage extends StatefulWidget {
  Map<String, dynamic> dataPenerima = {};

  DataPenerimaPage({super.key, required this.dataPenerima});

  @override
  State<DataPenerimaPage> createState() => _DataPenerimaPageState();
}

class _DataPenerimaPageState extends State<DataPenerimaPage> {
  List? dataKecamatan;
  int? selectedKecamatan;
  String? namaKecamatan;

  final TextEditingController _namaPenerimaController = TextEditingController();
  final TextEditingController _teleponPenerimaController =
      TextEditingController();
  final TextEditingController _detailPenerimaController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    // Cek dan set data dari parameter jika tidak kosong
    if (widget.dataPenerima.isNotEmpty) {
      _namaPenerimaController.text = widget.dataPenerima['nama_penerima'] ?? '';
      _teleponPenerimaController.text =
          widget.dataPenerima['telepon_penerima'] ?? '';
      _detailPenerimaController.text =
          widget.dataPenerima['detail_alamat_penerima'] ?? '';
      selectedKecamatan = widget.dataPenerima['id_kecamatan'];
      namaKecamatan = widget.dataPenerima['nama_kecamatan'];
    }

    _namaPenerimaController.addListener(() => setState(() {}));
    _teleponPenerimaController.addListener(() => setState(() {}));
    _detailPenerimaController.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final otherProvider = Provider.of<OtherProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      showDialog(
        context: context,
        barrierDismissible: false, // Tidak bisa ditutup klik di luar
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await otherProvider.getAllKecamatan(
          authProvider.dataCustomer!.kabupaten,
        ); //await memastikan kamu benar-benar menunggu proses ambil data selesai.
        Navigator.pop(context);
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
    return _namaPenerimaController.text.isNotEmpty &&
        _teleponPenerimaController.text.isNotEmpty &&
        _detailPenerimaController.text.isNotEmpty &&
        selectedKecamatan != null &&
        _teleponPenerimaController.text.length >= 10;
  }

  @override
  void dispose() {
    _namaPenerimaController.dispose();
    _teleponPenerimaController.dispose();
    _detailPenerimaController.dispose();
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
          'Data Penerima',
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
                "Informasi Penerima",
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
                      text: 'Nama Penerima',
                      controller: _namaPenerimaController,
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
                      text: 'Nomor Telepon Penerima',
                      controller: _teleponPenerimaController,
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
                      text: 'Detail Alamat Penerima',
                      controller: _detailPenerimaController,
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
                      Navigator.pop(context,  {
                        'nama_penerima': _namaPenerimaController.text,
                        'telepon_penerima': _teleponPenerimaController.text,
                        'id_kecamatan': selectedKecamatan,
                        'nama_kecamatan': namaKecamatan,
                        'detail_alamat_penerima':
                            _detailPenerimaController.text,
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
