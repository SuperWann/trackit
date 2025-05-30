import 'package:flutter/material.dart';
import 'package:trackit_dev/models/orderCustomer.dart';
import 'package:trackit_dev/services/adminService.dart';

class AdminProvider with ChangeNotifier{
  final AdminService _adminService = AdminService();

List<OrderCustomerModel>? _orderCustomerNotAcceptedByKecamatan;
  List<OrderCustomerModel>? get orderCustomerNotAcceptedByKecamatan =>
      _orderCustomerNotAcceptedByKecamatan;

  Future<void> getDataOrderNotAcceptedByKecamatan(int idKecamatan) async {
    _orderCustomerNotAcceptedByKecamatan = await _adminService.getDataOrderNotAcceptedByKecamatan(
      idKecamatan,
    );
    notifyListeners();
  }
}
