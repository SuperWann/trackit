import 'package:flutter/material.dart';
import 'package:trackit_dev/models/coordinatePoint.dart';
import 'package:trackit_dev/models/orderCustomer.dart';
import 'package:trackit_dev/models/orderCustomerProcessed.dart';
import 'package:trackit_dev/models/trackingHistory.dart';
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
        Navigator.pushReplacementNamed(context, '/navbarCustomer');
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
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<OrderCustomerModel>? _orderCustomerNotAccepted;
  List<OrderCustomerModel>? get orderCustomerNotAccepted =>
      _orderCustomerNotAccepted;

  Future<void> getDataOrderNotAccepted(int idCustomer) async {
    _orderCustomerNotAccepted = await _customerService.getDataOrderNotAccepted(
      idCustomer,
    );
    notifyListeners();
  }

  List<OrderCustomerProcessedModel>? _orderCustomerProcessed;
  List<OrderCustomerProcessedModel>? get orderCustomerProcessed =>
      _orderCustomerProcessed;

  Future<void> getDataOrderProcessed(int idCustomer) async {
    _orderCustomerProcessed = await _customerService.getDataOrderProcessed(
      idCustomer,
    );
    notifyListeners();
  }

  CoordinatePointModel? _coordinatePoint;
  CoordinatePointModel? get coordinatePoint => _coordinatePoint;

  Future<void> getCoordinatesPoint({
    required int idPengirim,
    required int idPenerima,
  }) async {
    _coordinatePoint = await _customerService.getCoordinatesPoint(
      idPengirim,
      idPenerima,
    );
    notifyListeners();
  }

  List<TrackingHistoryModel>? _trackingHistory;
  List<TrackingHistoryModel>? get trackingHistory => _trackingHistory;

  Future<void> getTrackingHistory(String noResi) async {
    _trackingHistory = await _customerService.getTrackingHistory(noResi);
    print(_trackingHistory!.length);
    notifyListeners();
  }

  Future<bool> cancelOrder(BuildContext context, int idOrder) async {
    try {
      bool isSuccess = await _customerService.cancelOrder(idOrder);
      Navigator.pop(context); // tutup dialog konfirmasi atau loading

      if (isSuccess) {
        await showDialog(
          context: context,
          builder:
              (context) => YesDialog(
                title: "Success",
                content: "Order berhasil dibatalkan",
                onYes: () {
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, '/orderCustomer');
                },
              ),
        );
        return true;
      } else {
        await showDialog(
          context: context,
          builder:
              (context) => YesDialog(
                title: "Gagal",
                content: "Gagal membatalkan order",
                onYes: () => Navigator.pop(context),
              ),
        );
        return false;
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
      return false;
    }
  }
}
