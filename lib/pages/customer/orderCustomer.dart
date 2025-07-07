import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/models/orderCustomer.dart';
import 'package:trackit_dev/models/orderCustomerProcessed.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/providers/customerProvider.dart';
import 'package:intl/intl.dart';

class OrderCustomerPage extends StatefulWidget {
  static const routeName = '/orderCustomer';

  OrderCustomerPage({super.key});

  @override
  State<OrderCustomerPage> createState() => _OrderCustomerPageState();
}

class _OrderCustomerPageState extends State<OrderCustomerPage> {
  List<OrderCustomerModel>? orders;
  List<OrderCustomerProcessedModel>? ordersProcessed;
  List<OrderCustomerProcessedModel>? ordersFinished;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final customerProvider = Provider.of<CustomerProvider>(
        context,
        listen: false,
      );
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await customerProvider.getDataOrderNotAccepted(
        authProvider.dataCustomer!.id!,
      );
      setState(() {
        orders = customerProvider.orderCustomerNotAccepted;
        ordersProcessed =
            customerProvider.orderCustomerProcessed!
                .where((order) => order.idStatusPaket != 5)
                .toList();
        ordersFinished =
            customerProvider.orderCustomerProcessed!
                .where((order) => order.idStatusPaket == 5)
                .toList();
      });
    });
  }

  Future<void> _refreshOrders() async {
    try {
      final provider = Provider.of<CustomerProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final customerProvider = Provider.of<CustomerProvider>(
        context,
        listen: false,
      );

      await provider.getDataOrderNotAccepted(authProvider.dataCustomer!.id!);
      await customerProvider.getDataOrderProcessed(
        authProvider.dataCustomer!.id!,
      );

      setState(() {
        orders = provider.orderCustomerNotAccepted!;
        ordersProcessed = customerProvider.orderCustomerProcessed;
        ordersFinished =
            customerProvider.orderCustomerProcessed!
                .where((order) => order.idStatusPaket == 5)
                .toList();
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
    return TabBarView(
      children: [
        // TAB 1
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
                              '/detailOrderCustomer',
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
                            'Berat: ${order.beratPaket} kg\nWaktu: ${formatTanggal(order.createdAt.toIso8601String())}',
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
          child:
              ordersProcessed == null || ordersProcessed!.isEmpty
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
                      itemCount: ordersProcessed!.length,
                      itemBuilder: (context, index) {
                        final order = ordersProcessed![index];
                        return ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detailOrderAcceptedCustomer',
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
                            'Berat: ${order.beratPaket} kg\nWaktu: ${formatTanggal(order.createdAt.toIso8601String())}',
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

        //TAB 3
        RefreshIndicator(
          onRefresh: _refreshOrders,
          child:
              ordersFinished == null || ordersFinished!.isEmpty
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
                      itemCount: ordersFinished!.length,
                      itemBuilder: (context, index) {
                        final order = ordersFinished![index];
                        return ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detailOrderAcceptedCustomer',
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
                            'Berat: ${order.beratPaket} kg\nWaktu: ${formatTanggal(order.createdAt.toIso8601String())}',
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
