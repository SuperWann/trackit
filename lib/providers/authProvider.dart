import 'package:flutter/material.dart';
import 'package:trackit_dev/models/customer.dart';
import 'package:trackit_dev/services/authService.dart';

class AuthProvider with ChangeNotifier {
  late bool _isCustomerExist = false;
  final AuthService _authService = AuthService();

  bool get customerExist => _isCustomerExist;

  Future<void> checkUserByTelepon(String noTelepon) async {
    _isCustomerExist = await _authService.checkUserByTelepon(noTelepon);
    notifyListeners();
  }

  CustomerModel? _dataCustomer;
  CustomerModel? get dataCustomer => _dataCustomer;

  Future<void> getDataLoginCustomer(String noTelepon, String pin) async {
    _dataCustomer = await _authService.getDataLoginCustomer(noTelepon, pin);
    print(_dataCustomer);
    notifyListeners();
  }
}
