import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trackit_dev/config.dart';
import 'package:trackit_dev/models/kurir.dart';

class KurirService {
  final String _baseUrl =
      '${ApiConfig.baseUrl}'
              '/trackit/Kurir'
          .trim();
          
  Future<List<KurirModel>> getDataKurir() async {
    final response = await http.get(Uri.parse('$_baseUrl/DataKurir'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData.map((json) => KurirModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mendapatkan data kurir: ${response.body}');
    }
  }
}
