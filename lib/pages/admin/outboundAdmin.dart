import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
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
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea =
        (MediaQuery.of(context).size.width < 400 ||
                MediaQuery.of(context).size.height < 400)
            ? 250.0
            : 400.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
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
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      controller.pauseCamera();
      await showDialog(
        context: context,
        builder:
            (context) => YesDialog(
              title: "Success",
              content: "${scanData.code}",
              onYes: () => Navigator.pop(context),
            ),
      );
      controller.disposed;
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
    List<Widget> tabBar = [Text('Scan'), Text('Manual')];

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
              'Outbound Page',
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
                borderSide: BorderSide(color: Color(0xFF1F3A93), width: 4),
                insets: EdgeInsets.symmetric(horizontal: 8),
              ),
              unselectedLabelStyle: TextStyle(
                color: Color(0xFFD9D9D9),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),
              labelColor: Colors.black,
              labelPadding: EdgeInsets.symmetric(vertical: 20),
              labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [Expanded(flex: 5, child: _buildQrView(context)), Center()],
        ),
      ),
    );
  }
}
