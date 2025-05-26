class OrderCustomerModel {
  final int? idOrder;
  final int idCustomerOrder;
  final int idJenisPaket;
  final double beratPaket;
  final String namaPengirim;
  final String teleponPengirim;
  final String detailAlamatPengirim;
  final String namaPenerima;
  final String teleponPenerima;
  final String detailAlamatPenerima;
  final bool isAccepted;
  final String catatanKurir;
  final DateTime createdAt;

  OrderCustomerModel({
    this.idOrder,
    required this.idCustomerOrder,
    required this.idJenisPaket,
    required this.beratPaket,
    required this.namaPengirim,
    required this.teleponPengirim,
    required this.detailAlamatPengirim,
    required this.namaPenerima,
    required this.teleponPenerima,
    required this.detailAlamatPenerima,
    required this.isAccepted,
    required this.catatanKurir,
    required this.createdAt,
  });

  factory OrderCustomerModel.fromJson(Map<String, dynamic> json) =>
      OrderCustomerModel(
        idOrder: json['id_order'],
        idCustomerOrder: json['id_customer_order'],
        idJenisPaket: json['id_jenis_paket'],
        beratPaket: (json['berat'] as num).toDouble(),
        namaPengirim: json['nama_pengirim'],
        teleponPengirim: json['telepon_pengirim'],
        detailAlamatPengirim: json['detail_alamat_pengirim'],
        namaPenerima: json['nama_penerima'],
        teleponPenerima: json['telepon_penerima'],
        detailAlamatPenerima: json['detail_alamat_penerima'],
        isAccepted: json['isAccepted'],
        catatanKurir: json['catatan_kurir'],
        createdAt: DateTime.parse(json['waktu_order']),
      );

  Map<String, dynamic> toJson() => {
    'id_customer_order': idCustomerOrder,
    'id_jenis_paket': idJenisPaket,
    'berat': beratPaket,
    'nama_pengirim': namaPengirim,
    'telepon_pengirim': teleponPengirim,
    'detail_alamat_pengirim': detailAlamatPengirim,
    'nama_penerima': namaPenerima,
    'telepon_penerima': teleponPenerima,
    'detail_alamat_penerima': detailAlamatPenerima,
    'isAccepted': isAccepted,
    'catatan_kurir': catatanKurir,
    'waktu_order': createdAt.toIso8601String(),
  };
}
