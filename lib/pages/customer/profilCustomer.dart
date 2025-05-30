import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/widgets/dialog.dart';

class ProfilCustomerPage extends StatelessWidget {
  static const String routeName = '/profilCustomer';
  const ProfilCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final customer = provider.dataCustomer!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Profil Customer'),
          Text('Nama: ${customer.id}'),
          Text('Nama: ${customer.nama}'),
          Text('telepon: ${customer.noTelepon}'),
          Text('pin: ${customer.pin}'),
          Text('kabupaten: ${customer.kabupaten}'),
          Text('kecamatan: ${customer.kecamatan}'),
          Text('detail: ${customer.detailAlamat}'),

          ElevatedButton(
            onPressed: () {
              try {
                showDialog(
                  context: context,
                  builder:
                      (context) => YesNoDialog(
                        title: 'Konfirmasi',
                        content: 'Anda Yakin Ingin Logout',
                        onYes: () {
                          provider.logout();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (_) => false,
                          );
                        },
                        onNo: () => Navigator.pop(context),
                      ),
                );
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (context) => CircularProgressIndicator(),
                );
                Navigator.of(context).pop();
              }
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
