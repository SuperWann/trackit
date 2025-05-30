import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trackit_dev/config.dart';
import 'package:trackit_dev/models/orderCustomer.dart';

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
}
