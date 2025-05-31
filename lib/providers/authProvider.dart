import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackit_dev/models/customer.dart';
import 'package:trackit_dev/models/loginPegawaiResp.dart';
import 'package:trackit_dev/services/authService.dart';

class AuthProvider with ChangeNotifier {
  //======================================================================= SESI LOGIN

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  // Panggil saat login sukses
  void login() {
    _isLoggedIn = true;
    // Simpan ke local storage
    _saveSession();
    notifyListeners();
  }

  // Logout
  void logout() async {
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    _dataCustomer = null;
    print(_dataCustomer);
    notifyListeners();
  }

  // Cek session di awal
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  //======================================================================= CHECK USER EXIST BY TELEPON

  late bool _isCustomerExist = false;
  final AuthService _authService = AuthService();

  bool get customerExist => _isCustomerExist;

  Future<void> checkUserByTelepon(String noTelepon) async {
    _isCustomerExist = await _authService.checkUserByTelepon(noTelepon);
    notifyListeners();
  }

  //======================================================================= GET DATA CUSTOMER LOGIN

  CustomerModel? _dataCustomer;
  CustomerModel? get dataCustomer => _dataCustomer;

  Future<void> getDataLoginCustomer(String noTelepon, String pin) async {
    _dataCustomer = await _authService.getDataLoginCustomer(noTelepon, pin);
    print(_dataCustomer!.id);
    notifyListeners();
  }

  //======================================================================= GET DATA PEGAWAI LOGIN

  LoginPegawaiResponseModel? _dataPegawai;
  LoginPegawaiResponseModel? get dataPegawai => _dataPegawai;

  Future<void> getDataLoginPegawai(String email, String password) async {
    _dataPegawai = await _authService.getDataLoginPegawai(email, password);
    notifyListeners();
  }
}
