import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackit_dev/models/orderCustomerProcessed.dart';
import 'package:trackit_dev/models/trackingHistory.dart';
import 'package:trackit_dev/providers/customerProvider.dart';
import 'package:trackit_dev/services/customerService.dart';
import 'package:trackit_dev/widgets/inputForm.dart';

class LacakResiCustomerPage extends StatefulWidget {
  static const routeName = '/lacakResiCustomer';

  const LacakResiCustomerPage({super.key});

  @override
  State<LacakResiCustomerPage> createState() => _LacakResiCustomerPageState();
}

class _LacakResiCustomerPageState extends State<LacakResiCustomerPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _noResiController = TextEditingController();
  late TabController _tabController;

  List<TrackingHistoryModel>? trackingHistory;
  List<OrderCustomerProcessedModel>? order;

  final CustomerProvider customerProvider = CustomerProvider();

  bool isLoading = false;
  String? error;

  Future<void> fetchTrackingHistory(BuildContext context, String noResi) async {
    setState(() {
      isLoading = true;
      error = null;
      // Reset data sebelumnya untuk memaksa rebuild
      trackingHistory = null;
      order = null;
    });

    // Simpan context untuk dialog
    bool dialogShown = false;

    try {
      FocusScope.of(context).unfocus();

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (dialogContext) => const Center(child: CircularProgressIndicator()),
      );
      dialogShown = true;

      await customerProvider.getTrackingHistory(noResi);
      final newTrackingHistory = customerProvider.trackingHistory;

      print('Tracking History: ${newTrackingHistory?.first.deskripsi}');

      await customerProvider.getDataOrderProcessedByResi(noResi);
      final newOrder = customerProvider.orderCustomerProcessed;

      print('Order: ${newOrder?.first.noResi}');

      // Close dialog
      if (dialogShown && mounted) {
        Navigator.of(context).pop();
        dialogShown = false;
      }

      // Update state
      setState(() {
        trackingHistory = newTrackingHistory;
        order = newOrder;
        isLoading = false;
      });
    } catch (e) {
      // Close dialog if still open
      if (dialogShown && mounted) {
        Navigator.of(context).pop();
      }

      setState(() {
        error = 'Gagal mengambil data tracking: ${e.toString()}';
        isLoading = false;
        trackingHistory = null;
        order = null;
      });

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error!), backgroundColor: Colors.red),
        );
      }
    }
  }

  String formatTanggal(String tanggalIso) {
    try {
      DateTime dt = DateTime.parse(tanggalIso);
      final formatter = DateFormat('HH:mm, \nd MMMM yyyy', 'id_ID');
      return formatter.format(dt);
    } catch (e) {
      return tanggalIso;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noResiController.dispose();
    super.dispose();
  }

  Widget _trackingTab() {
    final screenHeight = MediaQuery.of(context).size.height;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (trackingHistory == null || trackingHistory!.isEmpty) {
      return const Center(
        child: Text(
          'Data tracking tidak ditemukan',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: ListView.builder(
        itemCount: trackingHistory!.length,
        itemBuilder: (context, index) {
          final isLast = index == trackingHistory!.length - 1;
          final item = trackingHistory![index];

          return SizedBox(
            height: screenHeight * 0.1,
            child: Row(
              children: [
                // Waktu di kiri
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Text(
                    formatTanggal(order![0].createdAt.toIso8601String()),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1F3A93),
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(width: 2, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      item.deskripsi,
                      style: TextStyle(
                        color: isLast ? Colors.grey : const Color(0xFF1F3A93),
                        fontWeight: isLast ? FontWeight.w500 : FontWeight.w700,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _informasiTab() {
    if (order == null || order!.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada informasi pesanan',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Pesanan',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No Resi: ${order![0].noResi}',
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
            ),
          ),
          // Tambahkan informasi lainnya sesuai kebutuhan
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabBar = const [Tab(text: 'Tracking'), Tab(text: 'Informasi')];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFECF0F1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Lacak Resi',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.height * 0.25,
                        child:
                            order != null
                                ? switch (order![0].idStatusPaket) {
                                  1 => Image.asset(
                                    'assets/images/img_digudang.png',
                                  ),
                                  2 => Image.asset(
                                    'assets/images/diantar_kecamatan_penerima.png',
                                  ),
                                  3 => Image.asset(
                                    'assets/images/img_digudang.png',
                                  ),
                                  4 => Image.asset(
                                    'assets/images/menuju_alamat.png',
                                  ),
                                  _ => Image.asset('assets/images/paket_.png'),
                                }
                                : Image.asset('assets/images/paket_.png'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            tabs: tabBar,
                            dividerColor: Colors.transparent,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: UnderlineTabIndicator(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF1F3A93),
                                width: 4,
                              ),
                              insets: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            unselectedLabelStyle: const TextStyle(
                              color: Color(0xFFD9D9D9),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                            ),
                            labelColor: Colors.black,
                            labelPadding: const EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            labelStyle: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          // Perbaikan utama: Gunakan Expanded untuk TabBarView
                          Expanded(
                            child:
                                order != null && trackingHistory != null
                                    ? TabBarView(
                                      controller: _tabController,
                                      children: [
                                        _trackingTab(),
                                        _informasiTab(),
                                      ],
                                    )
                                    : const Center(
                                      child: Text(
                                        'Masukkan Nomor Resi',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black26,
                                        ),
                                      ),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: InputFormWithHintText(
                          type: TextInputType.text,
                          text: 'Masukkan Nomor Resi',
                          controller: _noResiController,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(70, 50),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          if (_noResiController.text.trim().isNotEmpty) {
                            fetchTrackingHistory(
                              context,
                              _noResiController.text.trim(),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Nomor resi tidak boleh kosong'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
