class ProsesOrderCustomerModel {
  final String noResi;
  final int? idOrder;
  final int? idKurir;
  final String deskripsi;
  final DateTime tanggalProses;

  ProsesOrderCustomerModel({
    required this.noResi,
    this.idOrder,
    this.idKurir,
    required this.deskripsi,
    required this.tanggalProses,
  });

  Map<String, dynamic> toJsonOrderAccepted() => {
    'no_resi': noResi,
    'id_order': idOrder,
    'id_kurir': idKurir,
    'deskripsi': deskripsi,
    'waktu': tanggalProses.toIso8601String(),
  };

  Map<String, dynamic> toJsonOrderProcessed() => {
    'no_resi': noResi,
    'deskripsi': deskripsi,
    'waktu': tanggalProses.toIso8601String(),
  };

  Map<String, dynamic> toJsonOrderSendKecamatanPenerima() => {
    'no_resi': noResi,
    'deskripsi': deskripsi,
    'waktu': tanggalProses.toIso8601String(),
    'id_kurir': idKurir,
  };
}
