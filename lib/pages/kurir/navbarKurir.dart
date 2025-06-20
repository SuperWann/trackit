import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/pages/kurir/ListKiriman.dart';
import 'package:trackit_dev/pages/kurir/profilKurir.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/providers/kurirProvider.dart';

class NavbarKurir extends StatefulWidget {
  static const String routeName = '/navbarKurir';

  const NavbarKurir({super.key});

  @override
  State<NavbarKurir> createState() => _NavbarKurirState();
}

class _NavbarKurirState extends State<NavbarKurir> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final kurirProvider = Provider.of<KurirProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

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
      return false;
    } else {
      SystemNavigator.pop();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [ListKirimanPage(), ProfilKurirPage()];

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
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
            }
          }(),
          body: pages[_selectedIndex],
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
                icon: Icon(Icons.my_library_books_outlined),
                label: 'Order',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
