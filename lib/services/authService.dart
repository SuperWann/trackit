import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trackit_dev/config.dart';
import 'package:trackit_dev/models/customer.dart';
import 'package:trackit_dev/models/loginPegawaiResp.dart';

class AuthService {
  final String _baseUrl =
      '${ApiConfig.baseUrl}'
              '/trackit/Auth'
          .trim();

  Future<bool> checkUserByTelepon(String noTelepon) async {
    final response = await http.get(Uri.parse('$_baseUrl/$noTelepon'));

    if (response.statusCode == 200) {
      print('User ditemukan');
      return true;
    }

    print('User tidak ditemukan: ${response.statusCode}');
    return false;
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

  Future<LoginPegawaiResponseModel?> getDataLoginPegawai(
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
      return LoginPegawaiResponseModel.fromJson(jsonData);
    } else {
      return null;
    }
  }
}
