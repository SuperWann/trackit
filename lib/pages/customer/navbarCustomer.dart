import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/models/customer.dart';
import 'package:trackit_dev/pages/customer/berandaCustomer.dart';
import 'package:trackit_dev/pages/customer/orderCustomer.dart';
import 'package:trackit_dev/pages/customer/profilCustomer.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/widgets/dialog.dart';

class NavbarCustomer extends StatefulWidget {
  static const routeName = '/navbarCustomer';

  const NavbarCustomer({super.key});

  @override
  State<NavbarCustomer> createState() => _NavbarCustomerState();
}

class _NavbarCustomerState extends State<NavbarCustomer> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    BerandaCustomerPage(),
    OrderCustomerPage(),
    ProfilCustomerPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Fungsi untuk konfirmasi apakah pengguna ingin keluar, saat klik tombol back
  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false; // Jangan keluar dulu
    } else {
      // Sudah di halaman Beranda
      bool logoutConfirm = await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Keluar Aplikasi'),
              content: Text('Apakah kamu yakin ingin logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Batal'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Logout'),
                ),
              ],
            ),
      );

      if (logoutConfirm) {
        Provider.of<AuthProvider>(context, listen: false).logout();
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
        return false;
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final CustomerModel customer =
        ModalRoute.of(context)?.settings.arguments as CustomerModel;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFECF0F1),

        appBar: () {
          switch (_selectedIndex) {
            case 0:
              return AppBar(
                backgroundColor: Colors.white,
                title: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text(
                    'Trackit!',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none_outlined),
                    ),
                  ),
                ],
                automaticallyImplyLeading: false,
              );
            case 1:
              return null;
            case 2:
              return null;
          }
        }(),

        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF1F3A93),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
          ),
          showSelectedLabels: true,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.my_library_books_outlined),
              label: 'Order',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
