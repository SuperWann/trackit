import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/models/listPengirimanKurir.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/providers/kurirProvider.dart';
import 'package:trackit_dev/providers/otherProvider.dart';

class ListKirimanPage extends StatefulWidget {
  static const String routeName = '/listkirimanPage';

  const ListKirimanPage({super.key});

  @override
  State<ListKirimanPage> createState() => _ListKirimanPageState();
}

class _ListKirimanPageState extends State<ListKirimanPage> {
  List<ListPengirimanKurirModel>? listPengiriman;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final kurirProvider = Provider.of<KurirProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final otherProvier = Provider.of<OtherProvider>(context, listen: false);

      await kurirProvider.getDataListPengiriman(
        authProvider.dataPegawai!.pegawai.id,
      );
      await otherProvier.getJenisPaket();
      await otherProvier.getAllKecamatan(
        authProvider.dataPegawai!.pegawai.kabupaten,
      );

      setState(() {
        listPengiriman = kurirProvider.listPengiriman;
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

  Future<void> _refreshOrder() async {
    try {
      final kurirProvider = Provider.of<KurirProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await kurirProvider.getDataListPengiriman(
        authProvider.dataPegawai!.pegawai.id,
      );

      setState(() {
        listPengiriman = kurirProvider.listPengiriman;
      });
    } catch (e) {
      print('Error saat refresh: $e');
    }
  }

  String formatTanggal(String tanggalIso) {
    DateTime dt = DateTime.parse(tanggalIso);
    final formatter = DateFormat('HH:mm, d MMMM yyyy', 'id_ID');
    return formatter.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshOrder,

      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child:
            listPengiriman == null || listPengiriman!.isEmpty
                ? Center(
                  child: Text(
                    "Belum Ada Pengiriman",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black26,
                    ),
                  ),
                )
                : Padding(
                  padding: EdgeInsets.all(20),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: listPengiriman!.length,
                    itemBuilder: (context, index) {
                      final list = listPengiriman![index];
                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detailOrderKurir',
                            arguments: list,
                          );
                        },
                        tileColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: Text(
                          '${list.namaPengirim.length > 10 ? '${list.namaPengirim.substring(0, 10)}...' : list.namaPengirim} → ${list.namaPenerima.length > 10 ? '${list.namaPenerima.substring(0, 10)}...' : list.namaPenerima}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right_rounded),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
