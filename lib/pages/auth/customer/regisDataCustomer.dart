import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/models/customer.dart';
import 'package:trackit_dev/models/kabupaten.dart';
import 'package:trackit_dev/models/registrasiCustomer.dart';
import 'package:trackit_dev/providers/customerProvider.dart';
import 'package:trackit_dev/providers/otherProvider.dart';
import 'package:trackit_dev/widgets/button.dart';
import 'package:trackit_dev/widgets/inputForm.dart';

class RegisDataCustomerPage extends StatefulWidget {
  static const routeName = '/regisDataCustomerPage';
  const RegisDataCustomerPage({super.key});

  @override
  State<RegisDataCustomerPage> createState() => _RegisDataCustomerPageState();
}

class _RegisDataCustomerPageState extends State<RegisDataCustomerPage> {
  List<KabupatenModel> dataKabupaten = [];
  List? dataKecamatan;

  int? idSelectedKabupaten;
  int? idSelectedKecamatan;
  bool isLoadingKecamatan = false;

  // Pindahkan controller ke state level
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _detailAlamatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadKabupaten());
  }

  Future<void> _loadKabupaten() async {
    final otherProvider = Provider.of<OtherProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await otherProvider.getDataKabupaten();

      if (mounted) {
        setState(() {
          dataKabupaten = otherProvider.dataKabupaten!;
        });
        Navigator.pop(context);
      }
      print('selesai load kabupaten');
      print(dataKabupaten);
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        print('Error loading kabupaten: $e');
      }
    }
  }

  Future<void> _loadKecamatan(int kabupatenId) async {
    final otherProvider = Provider.of<OtherProvider>(context, listen: false);

    setState(() {
      isLoadingKecamatan = true;
      idSelectedKecamatan = null;
    });

    try {
      await otherProvider.getAllKecamatanByIdKabupaten(kabupatenId);
      if (mounted) {
        setState(() {
          dataKecamatan = otherProvider.dataKecamatan;
          isLoadingKecamatan = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingKecamatan = false;
        });
        print('Error loading kecamatan: $e');
      }
    }
  }

  Future<void> _regisCustomer(BuildContext context) async {
    final args =
        ModalRoute.of(context)!.settings.arguments as RegistrasiCustomer;

    final customerProvider = Provider.of<CustomerProvider>(
      context,
      listen: false,
    );

    try {
      final dataCustomer = RegistrasiCustomer(
        nama: _namaController.text,
        telepon: args.telepon,
        pin: args.pin,
        detailAlamat: _detailAlamatController.text,
        idKecamatan: idSelectedKecamatan,
      );

      customerProvider.registrasiCustomer(dataCustomer, context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  bool isComplete() {
    return _namaController.text.isNotEmpty &&
        _detailAlamatController.text.isNotEmpty &&
        idSelectedKecamatan != null &&
        idSelectedKabupaten != null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Masukkan \nData Diri Anda",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Input Nama
                      const Text(
                        "Nama",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 8),
                      InputFormWithHintText(
                        type: TextInputType.text,
                        text: "Masukkan Nama",
                        controller: _namaController,
                      ),
                      const SizedBox(height: 16),

                      // Label Kabupaten
                      const Text(
                        "Kabupaten",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Dropdown Kabupaten
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 233, 233, 233),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            isExpanded: true,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                            value: idSelectedKabupaten,
                            hint: const Text(
                              'Pilih Kabupaten',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            items:
                                dataKabupaten.map<DropdownMenuItem<int>>((
                                  data,
                                ) {
                                  return DropdownMenuItem<int>(
                                    value: data.idKabupaten,
                                    child: Text(
                                      data.namaKabupaten!,
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) async {
                                  _loadKecamatan(value);
                                });
                                setState(() {
                                  idSelectedKabupaten = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        "Kecamatan",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 233, 233, 233),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            isLoadingKecamatan
                                ? const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text('Memuat kecamatan...'),
                                    ],
                                  ),
                                )
                                : DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    isExpanded: true,
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                    value: idSelectedKecamatan,
                                    hint: const Text(
                                      'Pilih Kecamatan',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    items:
                                        dataKecamatan
                                            ?.map<DropdownMenuItem<int>>((
                                              data,
                                            ) {
                                              return DropdownMenuItem<int>(
                                                value: data['id_kecamatan'],
                                                child: Text(
                                                  data['nama_kecamatan'],
                                                  style: const TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              );
                                            })
                                            .toList() ??
                                        [],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          idSelectedKecamatan = value;
                                        });
                                      }
                                    },
                                  ),
                                ),
                      ),
                      const SizedBox(height: 16),

                      // Input Detail Alamat
                      const Text(
                        "Detail Alamat",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 8),
                      InputFormWithHintText(
                        type: TextInputType.multiline,
                        text: "Detail Alamat",
                        controller: _detailAlamatController,
                      ),
                    ],
                  ),
                ),
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
                        child: LongButton(
                          text: "Daftar",
                          color: "#0D47A1",
                          colorText: "FFFFFF",
                          onPressed: () {
                            isComplete()
                                ? _regisCustomer(context)
                                : ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Data belum lengkap')),
                                );
                          },
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

  @override
  void dispose() {
    _namaController.dispose();
    _detailAlamatController.dispose();
    super.dispose();
  }
}
