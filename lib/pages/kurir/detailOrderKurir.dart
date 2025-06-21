import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/models/listPengirimanKurir.dart';
import 'package:trackit_dev/providers/otherProvider.dart';
import 'package:trackit_dev/widgets/button.dart';
import 'package:trackit_dev/widgets/dialog.dart';

class DetailOrderKurirPage extends StatefulWidget {
  static const String routeName = '/detailOrderKurir';

  const DetailOrderKurirPage({super.key});

  @override
  State<DetailOrderKurirPage> createState() => _DetailOrderKurirPageState();
}

class _DetailOrderKurirPageState extends State<DetailOrderKurirPage> {
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
    final ListPengirimanKurirModel dataPengiriman =
        ModalRoute.of(context)?.settings.arguments as ListPengirimanKurirModel;

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
        title: Text(
          "Detail",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w700,
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
                    rowData('Nama', dataPengiriman.namaPengirim),
                    rowData('Nomor Telepon', dataPengiriman.teleponPengirim),
                    rowData(
                      'Kecamatan',
                      getNamaKecamatan(dataPengiriman.idKecamatanPengirim),
                    ),
                    rowData('Alamat', dataPengiriman.detailAlamatPengirim),
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
                    rowData('Nama', dataPengiriman.namaPenerima),
                    rowData('Nomor Telepon', dataPengiriman.teleponPenerima),
                    rowData(
                      'Kecamatan',
                      getNamaKecamatan(dataPengiriman.idKecamatanPenerima),
                    ),
                    rowData('Alamat', dataPengiriman.detailAlamatPenerima),
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
                      getNamaJenisPaket(dataPengiriman.idJenisPaket),
                    ),
                    rowData('Berat', '${dataPengiriman.beratPaket} Kg'),
                    rowData('Catatan Kurir', dataPengiriman.catatanKurir),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            LongButton(
              text: "Selesaikan Order",
              color: "#1F3A93",
              colorText: "#FFFFFF",
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => YesNoDialog(
                        title: "Konfirmasi",
                        content: "Apakah anda yakin ingin menyelesaikan order?",
                        onYes: () async {},
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
