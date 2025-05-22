import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trackit_dev/models/customer.dart';
import 'package:trackit_dev/models/loginPegawaiResp.dart';

class AuthService {
  final String _baseUrl =
      'https://7b9f-203-29-27-165.ngrok-free.app' //harus sering diganti saat deploy menggunakan ngrok
              '/trackit/Auth'
          .trim();

  Future<bool> checkUserByTelepon(String noTelepon) async {
    final response = await http.get(Uri.parse('$_baseUrl/$noTelepon'));

    if (response.statusCode == 200) {
      print('User ditemukan');
      return true;
    } else {
      print('User tidak ditemukan: ${response.statusCode}');
      return false;
    }
  }

  Future<CustomerModel?> getDataLoginCustomer(
    String noTelepon,
    String pin,
  ) async {
    final url = Uri.parse('$_baseUrl/loginCustomer');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'no_telepon': noTelepon, 'pin': pin}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return CustomerModel.fromJson(jsonData[0]);
    } else {
      return null;
    }
  }

  Future<LoginPegawaiResponse?> getDataLoginPegawai(
    String email,
    String password,
  ) async {
    final url = Uri.parse('$_baseUrl/loginPegawai');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return LoginPegawaiResponse.fromJson(jsonData);
    } else {
      return null;
    }
  }
}
