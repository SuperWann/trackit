class OrderCustomerProcessedModel {
  final int? idOrder;
  final String noResi;
  final int idCustomerOrder;
  final int idJenisPaket;
  final int idStatusPaket;
  final double beratPaket;
  final String namaPengirim;
  final String teleponPengirim;
  final String detailAlamatPengirim;
  final int idKecamatanPengirim;
  final String namaPenerima;
  final String teleponPenerima;
  final String detailAlamatPenerima;
  final int idKecamatanPenerima;
  final bool isAccepted;
  final String? catatanKurir;
  final DateTime createdAt;
  final String namaKurir;

  OrderCustomerProcessedModel({
    this.idOrder,
    required this.noResi,
    required this.idCustomerOrder,
    required this.idJenisPaket,
    required this.idStatusPaket,
    required this.beratPaket,
    required this.namaPengirim,
    required this.teleponPengirim,
    required this.detailAlamatPengirim,
    required this.idKecamatanPengirim,
    required this.namaPenerima,
    required this.teleponPenerima,
    required this.detailAlamatPenerima,
    required this.idKecamatanPenerima,
    required this.isAccepted,
    this.catatanKurir,
    required this.createdAt,
    required this.namaKurir,
  });

  factory OrderCustomerProcessedModel.fromJson(Map<String, dynamic> json) =>
      OrderCustomerProcessedModel(
        idOrder: json['id_order'],
        noResi: json['no_resi'],
        idCustomerOrder: json['id_customer_order'],
        idJenisPaket: json['id_jenis_paket'],
        idStatusPaket: json['id_status_paket'],
        beratPaket: (json['berat'] as num).toDouble(),
        namaPengirim: json['nama_pengirim'],
        teleponPengirim: json['telepon_pengirim'],
        detailAlamatPengirim: json['detail_alamat_pengirim'],
        idKecamatanPengirim: json['id_kecamatan_pengirim'],
        namaPenerima: json['nama_penerima'],
        teleponPenerima: json['telepon_penerima'],
        detailAlamatPenerima: json['detail_alamat_penerima'],
        idKecamatanPenerima: json['id_kecamatan_penerima'],
        isAccepted: json['isAccepted'],
        catatanKurir: json['catatan_kurir'],
        createdAt: DateTime.parse(json['waktu_order']),
        namaKurir: json['nama_kurir'],
      );
}