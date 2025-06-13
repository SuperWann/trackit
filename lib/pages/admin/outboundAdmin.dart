import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:trackit_dev/models/orderCustomerProcessed.dart';
import 'package:trackit_dev/models/prosesOrderCustomer.dart';
import 'package:trackit_dev/providers/adminProvider.dart';
import 'package:trackit_dev/providers/otherProvider.dart';
import 'package:trackit_dev/widgets/dialog.dart';

class OutboundPage extends StatefulWidget {
  static const routeName = '/outboundPage';

  const OutboundPage({super.key});

  @override
  State<OutboundPage> createState() => _OutboundPageState();
}

class _OutboundPageState extends State<OutboundPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  List<OrderCustomerProcessedModel>? dataOrder;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea =
        (MediaQuery.of(context).size.width < 400 ||
                MediaQuery.of(context).size.height < 400)
            ? 250.0
            : 400.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final otherProvider = Provider.of<OtherProvider>(context, listen: false);

    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      controller.pauseCamera();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      try {
        await adminProvider.getDataOrderProcessedByResi(scanData.code!);
        dataOrder = adminProvider.orderCustomerProcessedByResi;

        if (dataOrder == null || dataOrder!.isEmpty) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data order tidak ditemukan")),
          );
          controller.resumeCamera();
          return;
        }

        final idStatusPaket = dataOrder!.first.idStatusPaket;

        String kecamatanPengirim =
            otherProvider.dataKecamatan!.firstWhere(
              (e) => e['id_kecamatan'] == dataOrder!.first.idKecamatanPengirim,
            )['nama_kecamatan'];

        String kecamatanPenerima =
            otherProvider.dataKecamatan!.firstWhere(
              (e) => e['id_kecamatan'] == dataOrder!.first.idKecamatanPenerima,
            )['nama_kecamatan'];

        final prosesOrder = ProsesOrderCustomerModel(
          noResi: dataOrder!.first.noResi,
          deskripsi:
              "Paket dikirim dari agen kecamatan $kecamatanPengirim ke agen kecamatan $kecamatanPenerima.",
          tanggalProses: DateTime.now(),
        );

        Navigator.pop(context);

        switch (idStatusPaket) {
          case 1:
            print("Processing case 1");
            await adminProvider.orderSendKecamatanPenerima(
              context,
              prosesOrder,
            );
            break;
          case 2:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Paket sudah diantar ke gudang kecamatan penerima!",
                ),
              ),
            );
            break;
          case 3:
            print("Status 3");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Paket sudah di gudang kecamatan penerima"),
              ),
            );
            break;
          case 4:
            print("paket sudah diantar ke alamat penerima");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Paket sudah diantar ke alamat penerima"),
              ),
            );
            break;
          case 5:
            print("paket sudah terkirim");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Paket sudah terkirim")),
            );
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Status paket tidak dikenali")),
            );
        }
      } catch (e) {
        Navigator.pop(context);
        print("Error: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }

      controller.resumeCamera();
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('no Permission')));
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabBar = [const Text('Scan'), const Text('Manual')];

    return DefaultTabController(
      length: tabBar.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height * 0.12,
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Outbound',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            bottom: TabBar(
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
              labelPadding: const EdgeInsets.symmetric(vertical: 20),
              labelStyle: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildQrView(context),
            const Center(child: Text('Manual Tab Content')),
          ],
        ),
      ),
    );
  }
}
