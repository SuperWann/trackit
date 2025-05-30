import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/models/orderCustomer.dart';
import 'package:trackit_dev/providers/customerProvider.dart';
import 'package:trackit_dev/providers/otherProvider.dart';
import 'package:trackit_dev/widgets/button.dart';
import 'package:trackit_dev/widgets/dialog.dart';

class DetailOrderMenungguAdminPage extends StatefulWidget {
  static const String routeName = '/detailOrderAdmin';

  const DetailOrderMenungguAdminPage({super.key});

  @override
  State<DetailOrderMenungguAdminPage> createState() =>
      _DetailOrderMenungguAdminPageState();
}

class _DetailOrderMenungguAdminPageState
    extends State<DetailOrderMenungguAdminPage> {
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
            LongButton(
              text: "Proses Order   ->",
              color: "#1F3A93",
              colorText: "#FFFFFF",
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => YesNoDialog(
                        title: "Konfirmasi",
                        content:
                            "Apakah Anda yakin ingin memproses order? pastikan customer mendatangi gudang Anda!",
                        onYes: () async {
                          Navigator.pop(context);
                        },
                        onNo: () => Navigator.pop(context),
                      ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
