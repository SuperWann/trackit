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
}
