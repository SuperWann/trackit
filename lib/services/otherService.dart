import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trackit_dev/config.dart';

class OtherService {
  final String _baseUrl = '${ApiConfig.baseUrl}/trackit/other'.trim();

  Future<List<dynamic>> getJenisPaket() async {
    final response = await http.get(Uri.parse('$_baseUrl/DataJenisPaket'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getAllKecamatan(String namaKabupaten) async {
    final response = await http.get(Uri.parse('$_baseUrl/DataKecamatan/$namaKabupaten'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    } else {
      return [];
    }
  } 
}
