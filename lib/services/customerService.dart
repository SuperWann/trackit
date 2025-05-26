import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trackit_dev/config.dart';
import 'package:trackit_dev/models/orderCustomer.dart';

class CustomerService {
  final String _baseUrl =
      '${ApiConfig.baseUrl}'
              '/trackit/Customer'
          .trim();

  Future<bool> createOrder(OrderCustomerModel order) async {
    final url = Uri.parse('$_baseUrl/CreateOrder');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(order.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception('Gagal membuat order: ${response.body}');
  }

  Future<List<OrderCustomerModel>>? getDataOrderNotAccepted(int idCustomer) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/DataOrderNotAccepted/$idCustomer'),
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
