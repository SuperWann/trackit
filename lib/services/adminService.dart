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
          
  Future<List<OrderCustomerModel>>? getDataOrderNotAcceptedByKecamatan(int idKecamatan) async {
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

  Future<List<OrderCustomerProcessedModel>>? getDataOrderProcessedByKecamatanPengirim(int idKecamatan, int idStatus) async {
    final reponse = await http.get(
      Uri.parse('$_baseUrl/DataOrderProcessedByKecamatanPengirim/$idKecamatan/$idStatus'),
    );

    if (reponse.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(reponse.body);
      return jsonData.map((json) => OrderCustomerProcessedModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mendapatkan data order: ${reponse.body}');
    }
  }

  Future<bool> acceptOrder(ProsesOrderCustomerModel prosesOrder) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/AcceptOrder'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(prosesOrder.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception('Gagal accept order: ${response.body}!');
  }

}
