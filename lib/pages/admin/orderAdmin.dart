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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      print(adminProvider.orderCustomerProcessedByKecamatan!.length);
      // await adminProvider.getDataOrderNotAcceptedByKecamatan(
      //   authProvider.dataPegawai!.pegawai.idKecamatan,
      // );
      setState(() {
        orders = adminProvider.orderCustomerNotAcceptedByKecamatan;
        ordersDigudang =
            adminProvider.orderCustomerProcessedByKecamatan!
                .where((order) => order.idStatusPaket == 1)
                .toList();
        ordersDiantar =
            adminProvider.orderCustomerProcessedByKecamatan!
                .where((order) => order.idStatusPaket == 2)
                .toList();
      });
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
        ordersDigudang = adminProvider.orderCustomerProcessedByKecamatan;
        ordersDiantar = adminProvider.orderCustomerProcessedByKecamatan;
      });
    } catch (e) {
      print('Error saat refresh: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
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
                          trailing: Icon(
                            Icons.timelapse,
                            color: Color.fromARGB(255, 255, 208, 0),
                          ),
                        );
                      },
                    ),
                  ),
        ),
        RefreshIndicator(
          onRefresh: _refreshOrders,
          child:
              ordersDigudang == null || ordersDigudang!.isEmpty
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
                      itemCount: ordersDigudang!.length,
                      itemBuilder: (context, index) {
                        final order = ordersDigudang![index];
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
                            Icons.warehouse_rounded,
                            color: Color.fromARGB(255, 255, 208, 0),
                          ),
                        );
                      },
                    ),
                  ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [Text('3')]),
        ),
      ],
    );
  }
}
