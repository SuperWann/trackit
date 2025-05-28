import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/models/orderCustomer.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/providers/customerProvider.dart';

class OrderCustomerPage extends StatefulWidget {
  static const routeName = '/orderCustomer';

  OrderCustomerPage({super.key});

  @override
  State<OrderCustomerPage> createState() => _OrderCustomerPageState();
}

class _OrderCustomerPageState extends State<OrderCustomerPage> {
  List<OrderCustomerModel>? orders;

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
        authProvider.dataCustomer!.id,
      );
      setState(() {
        orders = customerProvider.orderCustomerNotAccepted;
      });
    });
  }

  Future<void> _refreshOrders() async {
    try {
      final provider = Provider.of<CustomerProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await provider.getDataOrderNotAccepted(authProvider.dataCustomer!.id);
      // provider.orderCustomerNotAccepted;
      setState(() {
        orders = provider.orderCustomerNotAccepted!;
      });
    } catch (e) {
      print('Error saat refresh: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(orders[1].idOrder);
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
                              '/detailOrder',
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
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [Text('2')]),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [Text('3')]),
        ),
      ],
    );
  }
}
