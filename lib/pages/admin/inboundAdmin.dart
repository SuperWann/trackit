import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:trackit_dev/models/kurir.dart';
import 'package:trackit_dev/models/orderCustomerProcessed.dart';
import 'package:trackit_dev/models/prosesOrderCustomer.dart';
import 'package:trackit_dev/providers/adminProvider.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/providers/kurirProvider.dart';
import 'package:trackit_dev/providers/otherProvider.dart';
import 'package:trackit_dev/widgets/button.dart';
import 'package:trackit_dev/widgets/inputForm.dart';

class InboundPage extends StatefulWidget {
  static const routeName = '/inboundPage';

  const InboundPage({super.key});

  @override
  State<InboundPage> createState() => _InboundPageState();
}

class _InboundPageState extends State<InboundPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  List<OrderCustomerProcessedModel>? dataOrder;

  final TextEditingController _noResiController = TextEditingController();

  List<KurirModel>? kurirs;
  int? idSelectedKurir;
  int? idKecamatanKurir;

  @override
  void initState() {
    super.initState();
    final kurirProvider = Provider.of<KurirProvider>(context, listen: false);
    kurirs = kurirProvider.kurir;
  }

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

  Future<void> _showKurirSelectionDialog() async {
    // Reset selection
    idSelectedKurir = null;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  title: const Text(
                    'Pilih Kurir',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  content: SizedBox(
                    width: double.maxFinite,
                    child:
                        kurirs == null || kurirs!.isEmpty
                            ? const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Memuat data kurir...'),
                              ],
                            )
                            : DropdownButton<int>(
                              dropdownColor: Colors.white,
                              isExpanded: true,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                              underline: Container(),
                              disabledHint: const Text(
                                'Kurir',
                                style: TextStyle(
                                  color: Colors.black12,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              value: idSelectedKurir,
                              hint: const Text(
                                'Pilih kurir pengirim',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              items:
                                  kurirs!
                                      .map(
                                        (kurir) => DropdownMenuItem<int>(
                                          value: kurir.idKurir,
                                          child: Text(kurir.nama),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (value) {
                                setDialogState(() {
                                  idSelectedKurir = value;
                                  idKecamatanKurir =
                                      kurirs!
                                          .firstWhere(
                                            (kurir) =>
                                                kurir.idKurir ==
                                                idSelectedKurir,
                                          )
                                          .idKecamatan;
                                });
                              },
                            ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        idSelectedKurir = null;
                        Navigator.pop(context);
                      },
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed:
                          idSelectedKurir != null
                              ? () {
                                Navigator.pop(context);
                              }
                              : null,
                      child: const Text('Pilih'),
                    ),
                  ],
                ),
          ),
    );
  }

  Future<void> _processOrder(String noResi) async {
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final otherProvider = Provider.of<OtherProvider>(context, listen: false);

    FocusScope.of(context).unfocus();

    await _showKurirSelectionDialog();

    try {
      await adminProvider.getDataOrderProcessedByResi(noResi);

      if (!mounted) return;

      final data = adminProvider.orderCustomerProcessedByResi;

      if (data == null || data.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data order tidak ditemukan")),
          );
        }
        return;
      }

      final idStatusPaket = data.first.idStatusPaket;

      String kecamatanPenerima =
          otherProvider.dataKecamatan!.firstWhere(
            (e) => e['id_kecamatan'] == data.first.idKecamatanPenerima,
          )['nama_kecamatan'];

      final kecamatanPenerimaAccept = ProsesOrderCustomerModel(
        noResi: data.first.noResi,
        idKurir: idSelectedKurir,
        deskripsi:
            "Barang telah diterima oleh: Agen kecamatan $kecamatanPenerima untuk diproses.",
        tanggalProses: DateTime.now(),
      );

      if (!mounted) return;

      switch (idStatusPaket) {
        case 1:
          if (mounted) {
            Navigator.pop(context);
            if (data.first.idKecamatanPengirim ==
                authProvider.dataPegawai!.pegawai.idKecamatan) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    "Kirim paket menuju agen penerima dengan scan pada halaman outbound!",
                  ),
                ),
              );
            }
          } else if (data.first.idKecamatanPenerima ==
              authProvider.dataPegawai!.pegawai.idKecamatan) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  "Paket sedang diproses oleh agen kecamatan pengirim!",
                ),
              ),
            );
          } else {
            if (mounted) {
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
            if (idSelectedKurir == null) {
              return;
            } else {
              if (data.first.idKecamatanPengirim ==
                  authProvider.dataPegawai!.pegawai.idKecamatan) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      "Paket sedang diantar menuju agen kecamatan penerima!",
                    ),
                  ),
                );
              } else if (data.first.idKecamatanPenerima ==
                  authProvider.dataPegawai!.pegawai.idKecamatan) {
                await adminProvider.orderAcceptedGudangKecamatanPenerima(
                  context,
                  kecamatanPenerimaAccept,
                );
                await adminProvider.getDataOrderProcessedByKecamatan(
                  authProvider.dataPegawai!.pegawai.idKecamatan,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      "Anda bukan agen yang bersangkutan, tidak bisa menginput data!",
                    ),
                  ),
                );
              }
            }
          }
          break;
        case 3:
          if (mounted) {
            // Navigator.pop(context);
            if (data.first.idKecamatanPengirim ==
                authProvider.dataPegawai!.pegawai.idKecamatan) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Paket sudah di agen kecamatan penerima"),
                ),
              );
            } else if (data.first.idKecamatanPenerima ==
                authProvider.dataPegawai!.pegawai.idKecamatan) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Kirim paket ke alamat penerima dengan scan pada halaman outbound!",
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    "Anda bukan agen kecamatan penerima, tidak bisa menginput data!",
                  ),
                ),
              );
            }
          }
          break;
        case 4:
          if (mounted) {
            Navigator.pop(context);

            if (data.first.idKecamatanPenerima ==
                authProvider.dataPegawai!.pegawai.idKecamatan) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Paket sedang diantar menuju alamat penerima"),
                ),
              );
            } else if (data.first.idKecamatanPengirim ==
                authProvider.dataPegawai!.pegawai.idKecamatan) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Paket sudah di agen kecamatan penerima"),
                ),
              );
            } else {
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
        case 5:
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Paket sudah terkirim menuju alamat penerima"),
              ),
            );
            if (data.first.idKecamatanPengirim !=
                    authProvider.dataPegawai!.pegawai.idKecamatan ||
                data.first.idKecamatanPenerima !=
                    authProvider.dataPegawai!.pegawai.idKecamatan) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    "Anda bukan agen kecamatan pengirim ataupun penerima!",
                  ),
                ),
              );
            }
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
                'Inbound',
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
