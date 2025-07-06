import 'package:flutter/material.dart';
import 'package:trackit_dev/models/kurir.dart';
import 'package:trackit_dev/models/listPengirimanKurir.dart';
import 'package:trackit_dev/services/kurirService.dart';

class KurirProvider with ChangeNotifier {
  final KurirService _kurirService = KurirService();

  List<KurirModel>? _kurir;
  List<KurirModel>? get kurir => _kurir;
  Future<void> getDataKurir(int idKecamatan) async {
    _kurir = await _kurirService.getDataKurir(idKecamatan);
    notifyListeners();
  }

  List<ListPengirimanKurirModel>? _listPengiriman;
  List<ListPengirimanKurirModel>? get listPengiriman => _listPengiriman;

  Future<void> getDataListPengiriman(int idKurir) async {
    _listPengiriman = await _kurirService.getDataListPengirimanKurir(idKurir);
    notifyListeners();
  }
}
