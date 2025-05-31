import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit_dev/models/orderCustomer.dart';
import 'package:trackit_dev/pages/customer/inputDataPenerima.dart';
import 'package:trackit_dev/pages/customer/inputDataPengirim.dart';
import 'package:trackit_dev/providers/authProvider.dart';
import 'package:trackit_dev/providers/customerProvider.dart';
import 'package:trackit_dev/providers/otherProvider.dart';
import 'package:trackit_dev/widgets/button.dart';
import 'package:trackit_dev/widgets/dialog.dart';
import 'package:trackit_dev/widgets/inputForm.dart';

class OrderCustomerFormPage extends StatefulWidget {
  static const routeName = '/orderFormCustomer';

  const OrderCustomerFormPage({super.key});

  @override
  State<OrderCustomerFormPage> createState() => _OrderCustomerFormPageState();
}

class _OrderCustomerFormPageState extends State<OrderCustomerFormPage> {
  List? jenisPaket;
  List? kecamatan;
  OrderCustomerModel? order;

  // INPUTAN DATA ORDER
  int? idCustomerOrder;
  int? selectedJenisPaket;
  Map<String, dynamic> dataPengirim = {};
  Map<String, dynamic> dataPenerima = {};
  final TextEditingController _beratController = TextEditingController();
  final TextEditingController _catatanKurirController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final otherProvider = Provider.of<OtherProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      _beratController.addListener(() => setState(() {}));
      _catatanKurirController.addListener(() => setState(() {}));

      idCustomerOrder = authProvider.dataCustomer!.id;

      setState(() {
        jenisPaket = otherProvider.dataJenisPaket;
      });
    });
  }

  void _dataPengirimPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DataPengirimPage(dataPengirim: dataPengirim),
      ),
    );
    if (result != null) {
      setState(() {
        dataPengirim = Map<String, dynamic>.from(result);
      });
    }
  }

  void _dataPenerimaPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DataPenerimaPage(dataPenerima: dataPenerima),
      ),
    );
    if (result != null) {
      setState(() {
        dataPenerima = Map<String, dynamic>.from(result);
      });
    }
  }

  bool isComplete() {
    return selectedJenisPaket != null &&
        idCustomerOrder != null &&
        dataPengirim.isNotEmpty &&
        dataPenerima.isNotEmpty &&
        _beratController.text.isNotEmpty;
  }

  bool isValid() {
    return dataPengirim['id_kecamatan'] != dataPenerima['id_kecamatan'] &&
        dataPengirim['telepon_pengirim'] != dataPenerima['telepon_penerima'];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    final customerProvider = Provider.of<CustomerProvider>(
      context,
      listen: false,
    );

    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xFFECF0F1),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Pemesanan',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                SizedBox(
                  height: screenHeight * 0.25,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/img_2.jpg',
                    fit: BoxFit.cover,
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.20),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                highlightColor: Colors.transparent,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.circle_outlined,
                                    color: Color(0xFF0D47A1),
                                    size: 20,
                                  ),
                                  title:
                                      dataPengirim.isEmpty
                                          ? Text(
                                            'Pengirim',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          )
                                          : Text.rich(
                                            maxLines: 1,
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${(dataPengirim['nama_pengirim'] as String).length > 8 ? dataPengirim['nama_pengirim'].substring(0, 8) + '...' : dataPengirim['nama_pengirim']}',
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '  ${dataPengirim['telepon_pengirim']}',
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  subtitle: Text(
                                    dataPengirim.isEmpty
                                        ? "Alamat"
                                        : dataPengirim['nama_kecamatan'],
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                  ),
                                ),
                                onTap: () {
                                  _dataPengirimPage();
                                },
                              ),
                              InkWell(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.circle,
                                    color: Color(0xFF0D47A1),
                                    size: 20,
                                  ),
                                  title:
                                      dataPenerima.isEmpty
                                          ? Text(
                                            'Penerima',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          )
                                          : Text.rich(
                                            maxLines: 1, //maksimal line
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${(dataPenerima['nama_penerima'] as String).length > 8 ? dataPenerima['nama_penerima'].substring(0, 8) + '...' : dataPenerima['nama_penerima']}',
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '  ${dataPenerima['telepon_penerima']}',
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  subtitle: Text(
                                    dataPenerima.isEmpty
                                        ? "Alamat"
                                        : dataPenerima['nama_kecamatan'],
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                  ),
                                ),
                                onTap: () {
                                  _dataPenerimaPage();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Text(
                          "Informasi Barang",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 5,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Isi Paket",
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 35),
                                    Expanded(
                                      child: DropdownButton<int>(
                                        padding: EdgeInsets.only(
                                          right: 10,
                                          left: 10,
                                        ),
                                        isExpanded: true,
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                        underline: Container(),
                                        disabledHint: const Text(
                                          'Jenis paket',
                                          style: TextStyle(
                                            color: Colors.black12,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        value: selectedJenisPaket,
                                        hint: const Text(
                                          'Pilih jenis paket',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        items:
                                            jenisPaket == null
                                                ? []
                                                : jenisPaket!.map<
                                                  DropdownMenuItem<int>
                                                >((jenis) {
                                                  return DropdownMenuItem<int>(
                                                    value: jenis['id_jenis'],
                                                    child: Text(
                                                      jenis['nama_jenis'],
                                                    ),
                                                  );
                                                }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedJenisPaket = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text(
                                      "Berat (kg)",
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    Expanded(
                                      child: InputFormWithHintText(
                                        type: TextInputType.number,
                                        text: 'Masukkan berat paket',
                                        controller: _beratController,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Catatan Kurir",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      InputFormWithHintText(
                        type: TextInputType.text,
                        text: 'Masukkan catatan kurir',
                        controller: _catatanKurirController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Agar tidak full screen
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_sharp,
                        color: Color(0xFF1F3A93),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Saya menyetujui syarat & ketentuan',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                LongButton(
                  text: "Order",
                  color:
                      isComplete()
                          ? isValid()
                              ? "#1F3A93"
                              : "#C4C4C4"
                          : "#C4C4C4",
                  colorText: "#FFFFFF",
                  onPressed: () async {
                    isComplete()
                        ? isValid()
                            ? YesNoBottomDialog.show(
                              context,
                              title: 'Konfirmasi Order',
                              message:
                                  'Yakin dengan data Anda? data order tidak dapat diubah lagi',
                              yesText: 'Yakin!',
                              onYesPressed: () async {
                                customerProvider.isLoading
                                    ? CircularProgressIndicator()
                                    : order = OrderCustomerModel(
                                      idCustomerOrder: idCustomerOrder!,
                                      idJenisPaket: selectedJenisPaket!,
                                      beratPaket: double.parse(
                                        _beratController.text,
                                      ),
                                      namaPengirim:
                                          dataPengirim['nama_pengirim'],
                                      teleponPengirim:
                                          dataPengirim['telepon_pengirim'],
                                      detailAlamatPengirim:
                                          dataPengirim['detail_alamat_pengirim'],
                                      idKecamatanPengirim:
                                          dataPengirim['id_kecamatan'],
                                      namaPenerima:
                                          dataPenerima['nama_penerima'],
                                      teleponPenerima:
                                          dataPenerima['telepon_penerima'],
                                      detailAlamatPenerima:
                                          dataPenerima['detail_alamat_penerima'],
                                      idKecamatanPenerima:
                                          dataPenerima['id_kecamatan'],
                                      isAccepted: false,
                                      catatanKurir:
                                          _catatanKurirController.text,
                                      createdAt: DateTime.now(),
                                    );

                                // PROSES MEMBUAT ORDER
                                Future.delayed(
                                  const Duration(seconds: 2),
                                  () async {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                    );
                                    await customerProvider.createOrder(
                                      order!,
                                      context,
                                    );
                                  },
                                );
                              },
                              noText: 'Cek kembali',
                              onNoPressed: () {
                                // Navigator.pop(context);
                              },
                            )
                            :
                            // customerProvider.createOrder(order!, context)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Nomor telepon dan kecamatan tidak boleh sama!',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                              ),
                            )
                        : ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Data belum lengkap!',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.red,
                          ),
                        );
                  }, // Tombol tidak aktif kalau belum dicentang
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
