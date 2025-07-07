import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/models/kurir.dart';
import 'package:trackit_dev/models/orderCustomerProcessed.dart';
import 'package:trackit_dev/models/prosesOrderCustomer.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/providers/kurirProvider.dart';
import 'package:trackit_dev/providers/otherProvider.dart';
import 'package:intl/intl.dart';

class DetailOrderProcessedAdminPage extends StatefulWidget {
  static const String routeName = '/detailOrderProcessedAdmin';

  const DetailOrderProcessedAdminPage({super.key});

  @override
  State<DetailOrderProcessedAdminPage> createState() =>
      _DetailOrderProcessedAdminPageState();
}

class _DetailOrderProcessedAdminPageState
    extends State<DetailOrderProcessedAdminPage> {
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

      await kurirProvider.getDataKurir(
        authProvider.dataPegawai!.pegawai.idKecamatan,
      );
      setState(() {
        kurirs = kurirProvider.kurir;
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
    final OrderCustomerProcessedModel order =
        ModalRoute.of(context)?.settings.arguments
            as OrderCustomerProcessedModel;

    final otherProvider = Provider.of<OtherProvider>(context);
    final dataJenisPaket = otherProvider.dataJenisPaket!;
    final dataKecamatan = otherProvider.dataKecamatan!;

    Widget buildImageStatus(BuildContext context) {
      switch (order.idStatusPaket) {
        case 1:
          return Image.asset('assets/images/img_digudang.png');
        case 2:
          return Image.asset('assets/images/diantar_kecamatan_penerima.png');
        case 3:
          return Image.asset('assets/images/img_digudang.png');
        case 4:
          return Image.asset('assets/images/menuju_alamat.png');
        default:
          return Container();
      }
    }

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

    String formatTanggal(String tanggalIso) {
      DateTime dt = DateTime.parse(tanggalIso);

      // contoh format: 25 Mei 2025 19:08
      final formatter = DateFormat('d MMMM yyyy HH:mm', 'id_ID');

      return formatter.format(dt);
    }

    String statusPaket =
        otherProvider.dataStatusPaket!
            .firstWhere((item) => item.idStatusPaket == order.idStatusPaket)
            .statusPaket;

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
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.3,
            //   child: Center(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         SizedBox(
            //           height: MediaQuery.of(context).size.height * 0.2,
            //           child: buildImageStatus(context),
            //         ),
            //         SizedBox(height: 20),
            //         Text(
            //           statusPaket,
            //           style: TextStyle(
            //             fontWeight: FontWeight.w700,
            //             fontFamily: 'Montserrat',
            //             fontSize: 16,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Divider(),
            // SizedBox(height: 20),
            // Text(
            //   "Informasi Order",
            //   style: TextStyle(
            //     fontWeight: FontWeight.w700,
            //     fontFamily: 'Montserrat',
            //     fontSize: 16,
            //   ),
            // ),
            // Container(
            //   margin: const EdgeInsets.only(top: 10),
            //   padding: const EdgeInsets.all(20),
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     color: Colors.white,
            //   ),
            //   child: Material(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(15),
            //     child: Column(
            //       children: [
            //         SizedBox(height: 10),
            //         // ignore: deprecated_member_use
            //         PrettyQr(
            //           data: order.noResi,
            //           size: 120,
            //           elementColor: Colors.black,
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             SizedBox(width: 20),
            //             Text(
            //               order.noResi,
            //               style: TextStyle(
            //                 fontWeight: FontWeight.w700,
            //                 fontFamily: 'Montserrat',
            //                 fontSize: 16,
            //               ),
            //             ),
            //             IconButton(
            //               onPressed: () {
            //                 Clipboard.setData(
            //                   ClipboardData(text: order.noResi),
            //                 );
            //                 ScaffoldMessenger.of(context).showSnackBar(
            //                   const SnackBar(
            //                     content: Text('No Resi berhasil disalin!'),
            //                   ),
            //                 );
            //               },
            //               icon: Icon(Icons.copy, size: 20),
            //             ),
            //           ],
            //         ),
            //         rowData(
            //           'Jenis Barang',
            //           getNamaJenisPaket(order.idJenisPaket),
            //         ),
            //         rowData('Berat', '${order.beratPaket} Kg'),
            //         rowData(
            //           'Waktu Order',
            //           formatTanggal(order.createdAt.toIso8601String()),
            //         ),
            //         rowData('Catatan Kurir', order.catatanKurir!),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(height: 20),
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
              "Kurir Pengirim",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
                fontSize: 16,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                child: Column(children: [rowData('Nama', order.namaKurir)]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
