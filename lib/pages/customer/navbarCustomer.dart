import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/pages/customer/berandaCustomer.dart';
import 'package:trackit_dev/pages/customer/orderCustomer.dart';
import 'package:trackit_dev/pages/customer/profilCustomer.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/providers/customerProvider.dart';
import 'package:trackit_dev/providers/otherProvider.dart';

class NavbarCustomer extends StatefulWidget {
  static const routeName = '/navbarCustomer';

  const NavbarCustomer({super.key});

  @override
  State<NavbarCustomer> createState() => _NavbarCustomerState();
}

class _NavbarCustomerState extends State<NavbarCustomer> {
  int _selectedIndex = 0;
  // List<OrderCustomerModel>? orders;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final otherProvider = Provider.of<OtherProvider>(context, listen: false);
    final customerProvider = Provider.of<CustomerProvider>(
      context,
      listen: false,
    );

    final idCustomerLogin = authProvider.dataCustomer?.id ?? 0;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await otherProvider.getJenisPaket();
        await otherProvider.getAllKecamatan(
          authProvider.dataCustomer!.kabupaten,
        );
        await customerProvider.getDataOrderNotAccepted(idCustomerLogin);
        await customerProvider.getDataOrderProcessed(idCustomerLogin);
        await otherProvider.getDataStatusPaket();

        //Menutup dialog loading
        Navigator.pop(context);
      } catch (e) {
        //Menutup dialog loading
        Navigator.pop(context);
        print(e);
      }
    });
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
      return false; // Jangan keluar dulu
    } else {
      SystemNavigator.pop();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(
      context,
      listen: false,
    );

    List<Widget> pages = [
      BerandaCustomerPage(),
      OrderCustomerPage(),
      ProfilCustomerPage(),
    ];

    List<Widget> tabBar = [
      Text(
        'Belum\nDi Gudang (${customerProvider.orderCustomerNotAccepted?.length ?? 0})',
        textAlign: TextAlign.center,
      ),
      Text(
        'Proses (${customerProvider.orderCustomerProcessed?.where((order) => order.idStatusPaket != 5).length ?? 0})',
      ),
      Text(
        'Terkirim (${customerProvider.orderCustomerProcessed?.where((order) => order.idStatusPaket == 5).length ?? 0})',
      ),
    ];

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: DefaultTabController(
          length: tabBar.length,
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
                  return PreferredSize(
                    preferredSize: Size.fromHeight(
                      MediaQuery.of(context).size.height * 0.12,
                    ),
                    child: AppBar(
                      centerTitle: true,
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: SizedBox(
                          child: TextField(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/lacakResiCustomer',
                              );
                            },
                            decoration: InputDecoration(
                              fillColor: Color.fromARGB(255, 233, 233, 233),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Pencarian Waybill',
                              hintStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                color: Colors.black26,
                              ),
                            ),
                            keyboardType: TextInputType.none,
                          ),
                        ),
                      ),
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.white,
                      bottom: TabBar(
                        tabs: tabBar,
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: UnderlineTabIndicator(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFF1F3A93),
                            width: 4,
                          ),
                          insets: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        unselectedLabelStyle: TextStyle(
                          color: Color(0xFFD9D9D9),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                        ),
                        labelColor: Colors.black,
                        labelPadding: EdgeInsets.symmetric(vertical: 15),
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                case 2:
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
                  icon: Icon(Icons.home_rounded),
                  label: 'Beranda',
                ),
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
      ),
    );
  }
}
