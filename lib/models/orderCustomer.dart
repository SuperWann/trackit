class OrderCustomerModel {
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

  OrderCustomerModel({
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
  });

  factory OrderCustomerModel.fromJson(Map<String, dynamic> json) => OrderCustomerModel(
    idCustomerOrder: json['id_customer_order'],
    idJenisPaket: json['id_jenis_paket'],
    beratPaket: json['berat'],
    namaPengirim: json['nama_pengirim'],
    teleponPengirim: json['telepon_pengirim'],
    detailAlamatPengirim: json['detail_alamat_pengirim'],
    namaPenerima: json['nama_penerima'],
    teleponPenerima: json['telepon_penerima'],
    detailAlamatPenerima: json['detail_alamat_penerima'],
    isAccepted: json['isAccepted'],
    catatanKurir: json['catatan_kurir'],
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
  };
}
