import 'package:flutter/material.dart';
import 'package:trackit_dev/models/orderCustomer.dart';
import 'package:trackit_dev/services/customerService.dart';
import 'package:trackit_dev/widgets/dialog.dart';

class CustomerProvider with ChangeNotifier {
  final CustomerService _customerService = CustomerService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> createOrder(
    OrderCustomerModel order,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool isSuccess = await _customerService.createOrder(order);

      if (isSuccess) {
        Navigator.pop(context);
        await showDialog(
          context: context,
          builder:
              (context) => YesDialog(
                title: "Success",
                content: "Order berhasil dibuat",
                onYes: () => Navigator.pop(context),
              ),
        );
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        YesDialog(
          title: "Gagal",
          content: "Order gagal dibuat",
          onYes: Navigator.of(context).pop,
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
