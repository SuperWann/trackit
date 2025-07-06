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

  List<OrderCustomerProcessedModel>? _orderCustomerProcessedByKecamatan;
  List<OrderCustomerProcessedModel>? get orderCustomerProcessedByKecamatan =>
      _orderCustomerProcessedByKecamatan;

  Future<void> getDataOrderProcessedByKecamatan(int idKecamatan) async {
    _orderCustomerProcessedByKecamatan = await _adminService
        .getDataOrderProcessedByKecamatan(idKecamatan);
    notifyListeners();
  }

  List<OrderCustomerProcessedModel>? _orderCustomerProcessedByResi;
  List<OrderCustomerProcessedModel>? get orderCustomerProcessedByResi =>
      _orderCustomerProcessedByResi;

  Future<void> getDataOrderProcessedByResi(String noResi) async {
    _orderCustomerProcessedByResi = await _adminService
        .getDataOrderProcessedByResi(noResi);
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> orderAcceptedGudangKecamatanPengirim(
    BuildContext context,
    ProsesOrderCustomerModel prosesOrder,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool isSuccess = await _adminService.orderAcceptedGudangKecamatanPengirim(
        prosesOrder,
      );

      if (isSuccess) {
        Navigator.pop(context);
        await showDialog(
          context: context,
          builder:
              (context) => YesDialog(
                title: "Success",
                content: "Data order berhasil diinput ke gudang",
                onYes: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
        );
      }

      Navigator.pop(context);
      await showDialog(
        context: context,
        builder: (context) {
          return YesDialog(
            title: "Gagal",
            content: "Data order gagal diinput ke gudang",
            onYes: Navigator.of(context).pop,
          );
        },
      );
    } catch (e) {
      // Navigator.pop(context);
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> orderSendKecamatanPenerima(
    BuildContext context,
    ProsesOrderCustomerModel prosesOrder,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool isSuccess = await _adminService.orderSendKecamatanPenerima(
        prosesOrder,
      );

      if (isSuccess) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            content: Text("Data Order berhasil diinput untuk pengiriman"),
          ),
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
            content: Text("Data Order gagal diinput untuk pengiriman"),
          ),
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

  Future<void> orderAcceptedGudangKecamatanPenerima(
    BuildContext context,
    ProsesOrderCustomerModel prosesOrder,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool isSuccess = await _adminService.orderAcceptedGudangKecamatanPenerima(
        prosesOrder,
      );

      if (isSuccess) {
        // Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            content: Text("Data Order berhasil diinput!"),
          ),
        );
      } else {
        // Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
            content: Text("Data Order gagal diinput!"),
          ),
        );
      }
    } catch (e) {
      // Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> orderSendAlamatPenerima(
    BuildContext context,
    ProsesOrderCustomerModel prosesOrder,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool isSuccess = await _adminService.orderSendAlamatPenerima(prosesOrder);

      if (isSuccess) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            content: Text("Data Order berhasil diinput untuk pengiriman"),
          ),
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
            content: Text("Data Order gagal diinput untuk pengiriman"),
          ),
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
