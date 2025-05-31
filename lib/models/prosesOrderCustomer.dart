class ProsesOrderCustomerModel {
  final String noResi;
  final int idOrder;
  final int idKurir;
  final String deskripsi;
  final DateTime tanggalProses;

  ProsesOrderCustomerModel({
    required this.noResi,
    required this.idOrder,
    required this.idKurir,
    required this.deskripsi,
    required this.tanggalProses,
  });

  Map<String, dynamic> toJson() => {
    'no_resi': noResi,
    'id_order': idOrder,
    'id_kurir': idKurir,
    'deskripsi': deskripsi,
    'waktu': tanggalProses.toIso8601String(),
  };
}
