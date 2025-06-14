import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:trackit_dev/models/orderCustomerProcessed.dart';
import 'package:trackit_dev/models/prosesOrderCustomer.dart';
import 'package:trackit_dev/providers/adminProvider.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/providers/otherProvider.dart';
import 'package:trackit_dev/widgets/button.dart';
import 'package:trackit_dev/widgets/inputForm.dart';

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

  // PINDAHKAN CONTROLLER KE SINI (SEBAGAI INSTANCE VARIABLE)
  final TextEditingController _noResiController = TextEditingController();

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
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      if (!mounted) return;

      setState(() {
        result = scanData;
      });
      controller.pauseCamera();

      await _processOrder(scanData.code!);

      if (mounted) {
        controller.resumeCamera();
      }
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
    _noResiController.dispose();
    super.dispose();
  }

  Future<void> _processOrder(String noResi) async {
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final otherProvider = Provider.of<OtherProvider>(context, listen: false);

    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await adminProvider.getDataOrderProcessedByResi(noResi);

      if (!mounted) return;

      final data = adminProvider.orderCustomerProcessedByResi;

      if (data == null || data.isEmpty) {
        if (mounted) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data order tidak ditemukan")),
          );
        }
        return;
      }

      final idStatusPaket = data.first.idStatusPaket;
      String kecamatanPengirim =
          otherProvider.dataKecamatan!.firstWhere(
            (e) => e['id_kecamatan'] == data.first.idKecamatanPengirim,
          )['nama_kecamatan'];

      String kecamatanPenerima =
          otherProvider.dataKecamatan!.firstWhere(
            (e) => e['id_kecamatan'] == data.first.idKecamatanPenerima,
          )['nama_kecamatan'];

      final prosesOrder = ProsesOrderCustomerModel(
        noResi: data.first.noResi,
        deskripsi:
            "Barang dikirim dari agen kecamatan $kecamatanPengirim ke agen kecamatan $kecamatanPenerima.",
        tanggalProses: DateTime.now(),
      );

      if (!mounted) return;

      switch (idStatusPaket) {
        case 1:
          if (data.first.idKecamatanPengirim ==
              authProvider.dataPegawai!.pegawai.idKecamatan) {
            await adminProvider.orderSendKecamatanPenerima(
              context,
              prosesOrder,
            );
          } else {
            if (mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    "Anda bukan agen kecamatan pengirim, tidak bisa menginput data!",
                  ),
                ),
              );
            }
          }
          break;
        case 2:
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  "Paket sudah diantar ke gudang kecamatan penerima!",
                ),
              ),
            );
          }
          break;
        case 3:
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Paket sudah di gudang kecamatan penerima"),
              ),
            );
          }
          break;
        case 4:
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Paket sudah diantar ke alamat penerima"),
              ),
            );
          }
          break;
        case 5:
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Paket sudah terkirim")),
            );
          }
          break;
        default:
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Status paket tidak dikenali")),
            );
          }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabBar = [const Text('Scan'), const Text('Manual')];

    return DefaultTabController(
      length: tabBar.length,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(0xFFECF0F1),
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
              Container(
                height: double.infinity,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Masukkan No Resi",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          InputFormWithHintText(
                            type: TextInputType.text,
                            text: "No Resi",
                            controller: _noResiController,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    LongButton(
                      text: "Proses",
                      color: "#1F3A93",
                      colorText: "#FFFFFF",
                      onPressed: () async {
                        if (_noResiController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Silakan masukkan nomor resi"),
                            ),
                          );
                          return;
                        }

                        await _processOrder(_noResiController.text.trim());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
