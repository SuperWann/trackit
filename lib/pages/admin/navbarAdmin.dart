import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/pages/admin/berandaAdmin.dart';
import 'package:trackit_dev/pages/admin/orderAdmin.dart';
import 'package:trackit_dev/pages/admin/outboundAdmin.dart';
import 'package:trackit_dev/pages/admin/profilAdmin.dart';
import 'package:trackit_dev/providers/adminProvider.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/providers/kurirProvider.dart';
import 'package:trackit_dev/providers/otherProvider.dart';

class NavbarAdmin extends StatefulWidget {
  static const routeName = '/navbarAdmin';

  const NavbarAdmin({super.key});

  @override
  State<NavbarAdmin> createState() => _NavbarAdminState();
}

class _NavbarAdminState extends State<NavbarAdmin> {
  int _selectedIndex = 0;
  // int diGudang = 1;
  // int diAntar = 2;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final otherProvider = Provider.of<OtherProvider>(context, listen: false);
    final kurirProvider = Provider.of<KurirProvider>(context, listen: false);
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final idKecamatan = authProvider.dataPegawai!.pegawai.idKecamatan;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog(
        context: context,
        barrierDismissible: false, // Tidak bisa ditutup klik di luar
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await adminProvider.getDataOrderNotAcceptedByKecamatan(idKecamatan);
        await adminProvider.getDataOrderProcessedByKecamatan(idKecamatan);
        await kurirProvider.getDataKurir(
          authProvider.dataPegawai!.pegawai.idKecamatan,
        );
        await otherProvider.getJenisPaket();
        await otherProvider.getAllKecamatan(
          authProvider.dataPegawai!.pegawai.kabupaten,
        );
        await otherProvider.getDataStatusPaket();

        Navigator.pop(context);
      } catch (e) {
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
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    List<Widget> pages = [
      BerandaAdminPage(),
      OrderAdminPage(),
      ProfilAdminPage(),
    ];

    List<Widget> tabBar = [
      Text(
        'Belum\nDi Gudang (${adminProvider.orderCustomerNotAcceptedByKecamatan?.length ?? 0})',
        textAlign: TextAlign.center,
      ),
      Text(
        'Proses (${adminProvider.orderCustomerProcessedByKecamatan?.where((order) => order.idKecamatanPengirim == authProvider.dataPegawai!.pegawai.idKecamatan && order.idStatusPaket == 1 || order.idKecamatanPenerima == authProvider.dataPegawai!.pegawai.idKecamatan && order.idStatusPaket == 3 || order.idKecamatanPengirim == authProvider.dataPegawai!.pegawai.idKecamatan && order.idStatusPaket == 2 || order.idKecamatanPenerima == authProvider.dataPegawai!.pegawai.idKecamatan && order.idStatusPaket == 4).length ?? 0})',
      ),
      Text(
        'Terkirim (${adminProvider.orderCustomerProcessedByKecamatan?.where((order) => order.idKecamatanPengirim == authProvider.dataPegawai!.pegawai.idKecamatan && order.idStatusPaket > 2 || order.idKecamatanPenerima == authProvider.dataPegawai!.pegawai.idKecamatan && order.idStatusPaket > 4).length ?? 0})',
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
                case 3:
                  return AppBar();
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
                  label: 'Inbound',
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
