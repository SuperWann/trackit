import 'package:flutter/widgets.dart';
import 'package:trackit_dev/services/otherService.dart';

class OtherProvider with ChangeNotifier {
  final OtherService _otherService = OtherService();

  //======================================================================= GET DATA JENIS PAKET

  List<dynamic>? _dataJenisPaket = [];
  List<dynamic>? get dataJenisPaket => _dataJenisPaket;

  Future<void> getJenisPaket() async {
    _dataJenisPaket = await _otherService.getJenisPaket();
    notifyListeners();
  }

  //======================================================================= GET DATA KECAMATAN

  List<dynamic>? _dataKecamatan = [];
  List<dynamic>? get dataKecamatan => _dataKecamatan;

  Future<void> getAllKecamatan(String namaKabupaten) async {
    _dataKecamatan = await _otherService.getAllKecamatan(namaKabupaten);
    notifyListeners();
  }
}
