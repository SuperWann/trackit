import 'package:flutter/material.dart';
import 'package:trackit_dev/models/kurir.dart';
import 'package:trackit_dev/services/kurirService.dart';

class KurirProvider with ChangeNotifier {
  final KurirService _kurirService = KurirService();

  List<KurirModel>? _kurir;
  List<KurirModel>? get kurir => _kurir;

  Future<void> getDataKurir() async {
    _kurir = await _kurirService.getDataKurir();
    notifyListeners();
  }
}
