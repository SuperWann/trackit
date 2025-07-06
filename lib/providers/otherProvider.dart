import 'package:flutter/widgets.dart';
import 'package:trackit_dev/models/kabupaten.dart';
import 'package:trackit_dev/models/statusPaket.dart';
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

  Future<void> getAllKecamatanByIdKabupaten(int idKabupaten) async {
    _dataKecamatan = await _otherService.getAllKecamatanByIdKabupaten(
      idKabupaten,
    );
    notifyListeners();
  }

  Future<void> getAllKecamatan(String namaKabupaten) async {
    _dataKecamatan = await _otherService.getAllKecamatan(namaKabupaten);
    notifyListeners();
  }

  //======================================================================= GET DATA STATUS PAKET
  List<StatusPaketModel>? _dataStatusPaket;
  List<StatusPaketModel>? get dataStatusPaket => _dataStatusPaket;

  Future<void> getDataStatusPaket() async {
    _dataStatusPaket = await _otherService.getDataStatusPaket();
    notifyListeners();
  }

  //======================================================================= GET DATA KABUPATEN
  List<KabupatenModel>? _dataKabupaten;
  List<KabupatenModel>? get dataKabupaten => _dataKabupaten;

  Future<void> getDataKabupaten() async {
    _dataKabupaten = await _otherService.getDataKabupaten();
    notifyListeners();
  }
}
