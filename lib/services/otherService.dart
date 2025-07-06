import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trackit_dev/config.dart';
import 'package:trackit_dev/models/kabupaten.dart';
import 'package:trackit_dev/models/statusPaket.dart';

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

  Future<List<dynamic>> getAllKecamatanByIdKabupaten(int idKabupaten) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/DataKecamatanByIdKabupaten/$idKabupaten'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getAllKecamatan(String namaKabupaten) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/DataKecamatan/$namaKabupaten'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    } else {
      return [];
    }
  }

  Future<List<StatusPaketModel>> getDataStatusPaket() async {
    final response = await http.get(Uri.parse('$_baseUrl/DataStatusPaket'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => StatusPaketModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mendapatkan data status paket: ${response.body}');
    }
  }

  Future<List<KabupatenModel>>? getDataKabupaten() async {
    final response = await http.get(Uri.parse('$_baseUrl/DataKabupaten'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => KabupatenModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mendapatkan data kabupaten: ${response.body}');
    }
  }
}
