class ProsesOrderCustomerModel {
  final String noResi;
  final int idOrder;
  final int idKurir;

  ProsesOrderCustomerModel({
    required this.noResi,
    required this.idOrder,
    required this.idKurir,
  });

  Map<String, dynamic> toJson() => {
    'no_resi': noResi,
    'id_order': idOrder,
    'id_kurir': idKurir,
  };
}
