import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/models/kurir.dart';
import 'package:trackit_dev/models/orderCustomer.dart';
import 'package:trackit_dev/models/prosesOrderCustomer.dart';
import 'package:trackit_dev/providers/adminProvider.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/providers/kurirProvider.dart';
import 'package:trackit_dev/providers/otherProvider.dart';
import 'package:trackit_dev/widgets/button.dart';
import 'package:trackit_dev/widgets/dialog.dart';

class DetailOrderNotAcceptedAdminPage extends StatefulWidget {
  static const String routeName = '/detailOrderAdmin';

  const DetailOrderNotAcceptedAdminPage({super.key});

  @override
  State<DetailOrderNotAcceptedAdminPage> createState() =>
      _DetailOrderNotAcceptedAdminPageState();
}

class _DetailOrderNotAcceptedAdminPageState
    extends State<DetailOrderNotAcceptedAdminPage> {
  List<KurirModel>? kurirs;

  ProsesOrderCustomerModel? prosesOrder;
  int? idSelectedKurir;
  int? idKecamatanKurir;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final kurirProvider = Provider.of<KurirProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await kurirProvider.getDataKurir();
      setState(() {
        kurirs =
            kurirProvider.kurir
                ?.where(
                  (kurir) =>
                      kurir.idKecamatan ==
                      authProvider.dataPegawai!.pegawai.idKecamatan,
                )
                .toList();
      });
    });
  }

  Widget rowData(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 10, child: Text(':')),
          Expanded(
            child: Text(
              value == '' ? '-' : value,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final OrderCustomerModel order =
        ModalRoute.of(context)?.settings.arguments as OrderCustomerModel;

    final authProvider = Provider.of<AuthProvider>(context);
    final adminProvider = Provider.of<AdminProvider>(context);
    final otherProvider = Provider.of<OtherProvider>(context);
    final dataJenisPaket = otherProvider.dataJenisPaket!;
    final dataKecamatan = otherProvider.dataKecamatan!;

    String getNamaJenisPaket(int id) {
      final jenis = dataJenisPaket.firstWhere(
        (item) => item['id_jenis'] == id,
        orElse: () => null,
      );
      if (jenis != null) {
        return jenis['nama_jenis'] ?? '-';
      } else {
        return '-';
      }
    }

    String getNamaKecamatan(int id) {
      final kecamatan = dataKecamatan.firstWhere(
        (item) => item['id_kecamatan'] == id,
        orElse: () => null,
      );
      if (kecamatan != null) {
        return kecamatan['nama_kecamatan'] ?? '-';
      } else {
        return '-';
      }
    }

    String generateResiWithDateTime() {
      final prefix = "TRCKIT";
      final now = DateTime.now();

      String dateTimePart =
          '${now.year.toString().padLeft(4, '0')}'
          '${now.month.toString().padLeft(2, '0')}'
          '${now.day.toString().padLeft(2, '0')}'
          '${now.hour.toString().padLeft(2, '0')}'
          '${now.minute.toString().padLeft(2, '0')}'
          '${now.second.toString().padLeft(2, '0')}';

      return prefix + dateTimePart;
    }

    return Scaffold(
      backgroundColor: Color(0xFFECF0F1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Detail Order',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Informasi Pengirim",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
                fontSize: 16,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  children: [
                    rowData('Nama', order.namaPengirim),
                    rowData('Nomor Telepon', order.teleponPengirim),
                    rowData(
                      'Kecamatan',
                      getNamaKecamatan(order.idKecamatanPengirim),
                    ),
                    rowData('Alamat', order.detailAlamatPengirim),
                    //[{id_kecamatan: 5, nama_kecamatan: Ambulu}, {id_kecamatan: 6, nama_kecamatan: Wuluhan}]
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Informasi Penerima",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
                fontSize: 16,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  children: [
                    rowData('Nama', order.namaPenerima),
                    rowData('Nomor Telepon', order.teleponPenerima),
                    rowData(
                      'Kecamatan',
                      getNamaKecamatan(order.idKecamatanPenerima),
                    ),
                    rowData('Alamat', order.detailAlamatPenerima),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Informasi Order",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
                fontSize: 16,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  children: [
                    rowData(
                      'Jenis Barang',
                      getNamaJenisPaket(order.idJenisPaket),
                    ),
                    rowData('Berat', '${order.beratPaket} Kg'),
                    rowData('Waktu Order', order.createdAt.toIso8601String()),
                    rowData('Catatan Kurir', order.catatanKurir!),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Kurir Pengirim",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
                fontSize: 16,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white, // Warna background tombol Dropdown
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<int>(
                dropdownColor: Colors.white,
                padding: EdgeInsets.only(right: 10, left: 10),
                isExpanded: true,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                underline: Container(),
                disabledHint: const Text(
                  'Kurir',
                  style: TextStyle(
                    color: Colors.black12,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: idSelectedKurir,
                hint: const Text(
                  'Pilih kurir pengirim',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                items:
                    kurirs == null
                        ? []
                        : kurirs!
                            .map(
                              (kurir) => DropdownMenuItem<int>(
                                value: kurir.idKurir,
                                child: Text(kurir.nama),
                              ),
                            )
                            .toList(),
                onChanged: (value) {
                  setState(() {
                    idSelectedKurir = value;
                    idKecamatanKurir =
                        kurirs!
                            .firstWhere(
                              (kurir) => kurir.idKurir == idSelectedKurir,
                            )
                            .idKecamatan;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            LongButton(
              text: "Proses Order   ->",
              color: "#1F3A93",
              colorText: "#FFFFFF",
              onPressed: () {
                if (idSelectedKurir == null) {
                  Fluttertoast.showToast(
                    msg: "Mohon pilih kurir terlebih dahulu",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xFFC5172E),
                    textColor: Colors.white,
                    fontSize: 16.0,
                    fontAsset: 'assets/fonts/Montserrat-Medium.ttf',
                  );
                } else {
                  showDialog(
                    context: context,
                    builder:
                        (context) => YesNoDialog(
                          title: "Konfirmasi",
                          content:
                              "Apakah anda yakin ingin memproses order? Pastikan customer telah memberikan barang ke gudang",
                          onYes: () async {
                            prosesOrder = ProsesOrderCustomerModel(
                              noResi: generateResiWithDateTime(),
                              idOrder: order.idOrder!,
                              idKurir: idSelectedKurir!,
                              deskripsi:
                                  "Barang telah diterima oleh: Agen kecamatan ${authProvider.dataPegawai!.pegawai.kecamatan} untuk diproses.",
                              tanggalProses: DateTime.now(),
                            );
                            await adminProvider.acceptOrder(
                              context,
                              prosesOrder!,
                            );
                          },
                          onNo: () => Navigator.pop(context),
                        ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
