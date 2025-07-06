import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trackit_dev/config.dart';
import 'package:trackit_dev/models/orderCustomer.dart';
import 'package:trackit_dev/models/orderCustomerProcessed.dart';
import 'package:trackit_dev/models/prosesOrderCustomer.dart';

class AdminService {
  final String _baseUrl =
      '${ApiConfig.baseUrl}'
              '/trackit/Admin'
          .trim();

  Future<List<OrderCustomerModel>>? getDataOrderNotAcceptedByKecamatan(
    int idKecamatan,
  ) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/DataOrderNotAcceptedByKecamatan/$idKecamatan'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      print(jsonData);

      return jsonData.map((json) => OrderCustomerModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mendapatkan data order: ${response.body}');
    }
  }

  Future<List<OrderCustomerProcessedModel>>? getDataOrderProcessedByResi(
    String noResi,
  ) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/DataOrderProcessedByResi/$noResi'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData
          .map((json) => OrderCustomerProcessedModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Gagal mendapatkan data order: ${response.body}');
    }
  }

  Future<List<OrderCustomerProcessedModel>>?
  getDataOrderProcessedByKecamatan(int idKecamatan) async {
    final reponse = await http.get(
      Uri.parse('$_baseUrl/DataOrderProcessedByKecamatan/$idKecamatan'),
    );

    if (reponse.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(reponse.body);
      print(jsonData);
      return jsonData
          .map((json) => OrderCustomerProcessedModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Gagal mendapatkan data order: ${reponse.body}');
    }
  }

  Future<bool> orderAcceptedGudangKecamatanPengirim(
    ProsesOrderCustomerModel prosesOrder,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/OrderAcceptedGudangKecamatanPengirim'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(prosesOrder.toJsonOrderAccepted()),
    );

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception('Gagal accept order: ${response.body}!');
  }

  Future<bool> orderSendKecamatanPenerima(
    ProsesOrderCustomerModel prosesOrder,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/OrderSendKecamatanPenerima'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(prosesOrder.toJsonOrderProcessed()),
    );

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception('Gagal proses order: ${response.body}!');
  }

  Future<bool> orderAcceptedGudangKecamatanPenerima(
    ProsesOrderCustomerModel prosesOrder,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/OrderAcceptedGudangKecamatanPenerima'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(prosesOrder.toJsonOrderAccepted()),
    );

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception('Gagal accept order: ${response.body}!');
  }

  Future<bool> orderSendAlamatPenerima(
    ProsesOrderCustomerModel prosesOrder,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/OrderSendAlamatPenerima'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(prosesOrder.toJsonOrderProcessed()),
    );

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception('Gagal proses order: ${response.body}!');
  }
}
