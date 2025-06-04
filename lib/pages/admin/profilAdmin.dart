import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/widgets/dialog.dart';

class ProfilAdminPage extends StatelessWidget {
  static const String routeName = '/profilAdmin';
  const ProfilAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dataPegawai = authProvider.dataPegawai!.pegawai;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Profil Admin'),
          Text('id: ${dataPegawai.id}'),
          Text('Nama: ${dataPegawai.nama}'),
          Text('Peran: ${dataPegawai.peran}'),
          Text('kabupaten: ${dataPegawai.kabupaten}'),
          Text('kecamatan: ${dataPegawai.kecamatan}'),

          ElevatedButton(
            onPressed: () {
              try {
                showDialog(
                  context: context,
                  builder:
                      (context) => YesDialog(
                        title: 'Konfirmasi',
                        content: 'Anda Yakin Ingin Logout',
                        onYes: () {
                          authProvider.logout();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (_) => false,
                          );
                        },
                      ),
                );
              } catch (e) {
                print(e);
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
