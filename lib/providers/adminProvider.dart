import 'package:flutter/material.dart';
import 'package:trackit_dev/models/orderCustomer.dart';
import 'package:trackit_dev/models/orderCustomerProcessed.dart';
import 'package:trackit_dev/models/prosesOrderCustomer.dart';
import 'package:trackit_dev/services/adminService.dart';
import 'package:trackit_dev/widgets/dialog.dart';

class AdminProvider with ChangeNotifier {
  final AdminService _adminService = AdminService();

  List<OrderCustomerModel>? _orderCustomerNotAcceptedByKecamatan;
  List<OrderCustomerModel>? get orderCustomerNotAcceptedByKecamatan =>
      _orderCustomerNotAcceptedByKecamatan;

  Future<void> getDataOrderNotAcceptedByKecamatan(int idKecamatan) async {
    _orderCustomerNotAcceptedByKecamatan = await _adminService
        .getDataOrderNotAcceptedByKecamatan(idKecamatan);
    notifyListeners();
  }

  List<OrderCustomerProcessedModel>? _orderCustomerProcessedDigudang;
  List<OrderCustomerProcessedModel>? get orderCustomerProcessedDigudang =>
      _orderCustomerProcessedDigudang;
      
  Future<void> getDataOrderProcessedDigudang(int idKecamatan, int idStatus) async {
    _orderCustomerProcessedDigudang = await _adminService
        .getDataOrderProcessedByKecamatanPengirim(idKecamatan, idStatus);
    notifyListeners();
  }

  List<OrderCustomerProcessedModel>? _orderCustomerProcessedDiantar;
  List<OrderCustomerProcessedModel>? get orderCustomerProcessedDiantar =>
      _orderCustomerProcessedDiantar;

  Future<void> getDataOrderProcessedDiantar(int idKecamatan, int idStatus) async {
    _orderCustomerProcessedDiantar = await _adminService
        .getDataOrderProcessedByKecamatanPengirim(idKecamatan, idStatus);
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> acceptOrder(
    BuildContext context,
    ProsesOrderCustomerModel prosesOrder,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool isSuccess = await _adminService.acceptOrder(prosesOrder);

      if (isSuccess) {
        Navigator.pop(context);
        await showDialog(
          context: context,
          builder:
              (context) => YesDialog(
                title: "Success",
                content: "Data order berhasil masuk gudang",
                onYes: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
        );
      }

      Navigator.pop(context);
      YesDialog(
        title: "Gagal",
        content: "Order gagal dibuat",
        onYes: Navigator.of(context).pop,
      );
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
}
