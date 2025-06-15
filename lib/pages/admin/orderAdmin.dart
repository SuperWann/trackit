import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/models/orderCustomer.dart';
import 'package:trackit_dev/models/orderCustomerProcessed.dart';
import 'package:trackit_dev/providers/adminProvider.dart';
import 'package:trackit_dev/providers/authProvider.dart';

class OrderAdminPage extends StatefulWidget {
  static const String routeName = '/orderAdmin';

  const OrderAdminPage({super.key});

  @override
  State<OrderAdminPage> createState() => _OrderAdminPageState();
}

class _OrderAdminPageState extends State<OrderAdminPage> {
  List<OrderCustomerModel>? orders;
  List<OrderCustomerProcessedModel>? ordersDigudang;
  List<OrderCustomerProcessedModel>? ordersDiantar;
  List<OrderCustomerProcessedModel>? ordersTerkirim;
  List<OrderCustomerProcessedModel>? ordersProcessed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      setState(() {
        orders = adminProvider.orderCustomerNotAcceptedByKecamatan;
        ordersDigudang =
            adminProvider.orderCustomerProcessedByKecamatan!
                .where(
                  (order) =>
                      order.idKecamatanPengirim ==
                              authProvider.dataPegawai!.pegawai.idKecamatan &&
                          order.idStatusPaket == 1 ||
                      order.idKecamatanPenerima ==
                              authProvider.dataPegawai!.pegawai.idKecamatan &&
                          order.idStatusPaket == 3,
                )
                .toList();
        ordersDiantar =
            adminProvider.orderCustomerProcessedByKecamatan!
                .where(
                  (order) =>
                      order.idKecamatanPengirim ==
                              authProvider.dataPegawai!.pegawai.idKecamatan &&
                          order.idStatusPaket == 2 ||
                      order.idKecamatanPenerima ==
                              authProvider.dataPegawai!.pegawai.idKecamatan &&
                          order.idStatusPaket == 4,
                )
                .toList();
        ordersTerkirim =
            adminProvider.orderCustomerProcessedByKecamatan!
                .where(
                  (order) =>
                      order.idKecamatanPengirim ==
                              authProvider.dataPegawai!.pegawai.idKecamatan &&
                          order.idStatusPaket > 2 ||
                      order.idKecamatanPenerima ==
                              authProvider.dataPegawai!.pegawai.idKecamatan &&
                          order.idStatusPaket > 4,
                )
                .toList();
      });

      ordersProcessed = ordersDigudang;
    });
  }

  Future<void> _refreshOrders() async {
    try {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await adminProvider.getDataOrderNotAcceptedByKecamatan(
        authProvider.dataPegawai!.pegawai.idKecamatan,
      );
      await adminProvider.getDataOrderProcessedByKecamatan(
        authProvider.dataPegawai!.pegawai.idKecamatan,
      );
      setState(() {
        orders = adminProvider.orderCustomerNotAcceptedByKecamatan!;
        ordersDigudang =
            adminProvider.orderCustomerProcessedByKecamatan!
                .where(
                  (order) =>
                      order.idKecamatanPengirim ==
                              authProvider.dataPegawai!.pegawai.idKecamatan &&
                          order.idStatusPaket == 1 ||
                      order.idKecamatanPenerima ==
                              authProvider.dataPegawai!.pegawai.idKecamatan &&
                          order.idStatusPaket == 3,
                )
                .toList();
        ordersDiantar =
            adminProvider.orderCustomerProcessedByKecamatan!
                .where(
                  (order) =>
                      order.idKecamatanPengirim ==
                              authProvider.dataPegawai!.pegawai.idKecamatan &&
                          order.idStatusPaket == 2 ||
                      order.idKecamatanPenerima ==
                              authProvider.dataPegawai!.pegawai.idKecamatan &&
                          order.idStatusPaket == 4,
                )
                .toList();
        ordersTerkirim =
            adminProvider.orderCustomerProcessedByKecamatan!
                .where(
                  (order) =>
                      order.idKecamatanPengirim ==
                              authProvider.dataPegawai!.pegawai.idKecamatan &&
                          order.idStatusPaket > 2 ||
                      order.idKecamatanPenerima ==
                              authProvider.dataPegawai!.pegawai.idKecamatan &&
                          order.idStatusPaket > 4,
                )
                .toList();

        if (dropdownValue == 'Di Gudang') {
          ordersProcessed = ordersDigudang;
        } else if (dropdownValue == 'Diantar') {
          ordersProcessed = ordersDiantar;
        }
      });
    } catch (e) {
      print('Error saat refresh: $e');
    }
  }

  String dropdownValue = 'Di Gudang';

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        //TAB 1
        RefreshIndicator(
          onRefresh: _refreshOrders,
          child:
              orders == null || orders!.isEmpty
                  ? Center(
                    child: Text(
                      "Belum Ada Order",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black26,
                      ),
                    ),
                  )
                  : Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView.separated(
                      separatorBuilder:
                          (context, index) => SizedBox(height: 10),
                      itemCount: orders!.length,
                      itemBuilder: (context, index) {
                        final order = orders![index];
                        return ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detailOrderAdmin',
                              arguments: order,
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
                            '${order.namaPengirim.length > 10 ? '${order.namaPengirim.substring(0, 10)}...' : order.namaPengirim} → ${order.namaPenerima.length > 10 ? '${order.namaPenerima.substring(0, 10)}...' : order.namaPenerima}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          subtitle: Text(
                            'Berat: ${order.beratPaket} kg\nWaktu: ${order.createdAt.toIso8601String()}',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right_rounded),
                        );
                      },
                    ),
                  ),
        ),

        //TAB 2
        RefreshIndicator(
          onRefresh: _refreshOrders,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: DropdownButton<String>(
                  underline: Container(),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  value: dropdownValue,
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                      if (dropdownValue == 'Di Gudang') {
                        ordersProcessed = ordersDigudang;
                      } else if (dropdownValue == 'Diantar') {
                        ordersProcessed = ordersDiantar;
                      }
                    });
                  },
                  items:
                      <String>[
                        'Di Gudang',
                        'Diantar',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
              ),
              Expanded(
                child:
                    ordersProcessed == null || ordersProcessed!.isEmpty
                        ? Center(
                          child: Text(
                            "Tidak ada order",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black26,
                            ),
                          ),
                        )
                        : Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: ListView.separated(
                            separatorBuilder:
                                (context, index) => SizedBox(height: 10),
                            itemCount: ordersProcessed!.length,
                            itemBuilder: (context, index) {
                              final order = ordersProcessed![index];
                              return ListTile(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/detailOrderProcessedAdmin',
                                    arguments: order,
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
                                  '${order.namaPengirim.length > 10 ? '${order.namaPengirim.substring(0, 10)}...' : order.namaPengirim} → ${order.namaPenerima.length > 10 ? '${order.namaPenerima.substring(0, 10)}...' : order.namaPenerima}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                subtitle: Text(
                                  'Berat: ${order.beratPaket} kg\nWaktu: ${order.createdAt.toIso8601String()}',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                ),
                              );
                            },
                          ),
                        ),
              ),
            ],
          ),
        ),

        //TAB 3
        RefreshIndicator(
          onRefresh: _refreshOrders,
          child:
              ordersTerkirim == null || ordersTerkirim!.isEmpty
                  ? Center(
                    child: Text(
                      "Belum Ada Order",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black26,
                      ),
                    ),
                  )
                  : Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView.separated(
                      separatorBuilder:
                          (context, index) => SizedBox(height: 10),
                      itemCount: ordersTerkirim!.length,
                      itemBuilder: (context, index) {
                        final order = ordersTerkirim![index];
                        return ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detailOrderProcessedAdmin',
                              arguments: order,
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
                            '${order.namaPengirim.length > 10 ? '${order.namaPengirim.substring(0, 10)}...' : order.namaPengirim} → ${order.namaPenerima.length > 10 ? '${order.namaPenerima.substring(0, 10)}...' : order.namaPenerima}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          subtitle: Text(
                            'Berat: ${order.beratPaket} kg\nWaktu: ${order.createdAt.toIso8601String()}',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right_rounded),
                        );
                      },
                    ),
                  ),
        ),
      ],
    );
  }
}
