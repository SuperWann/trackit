class ListPengirimanKurirModel{
  final int idOrder;
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
  final String catatanKurir;

  ListPengirimanKurirModel({
    required this.idOrder,
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
    required this.catatanKurir,
  });

  factory ListPengirimanKurirModel.fromJson(Map<String, dynamic> json) => ListPengirimanKurirModel(
    idOrder: json["id_order"],
    noResi: json["no_resi"],
    idCustomerOrder: json["id_customer_order"],
    idJenisPaket: json["id_jenis_paket"],
    idStatusPaket: json["id_status_paket"],
    beratPaket: (json['berat'] as num).toDouble(),
    namaPengirim: json["nama_pengirim"],
    teleponPengirim: json["telepon_pengirim"],
    detailAlamatPengirim: json["detail_alamat_pengirim"],
    idKecamatanPengirim: json["id_kecamatan_pengirim"],
    namaPenerima: json["nama_penerima"],
    teleponPenerima: json["telepon_penerima"],
    detailAlamatPenerima: json["detail_alamat_penerima"],
    idKecamatanPenerima: json["id_kecamatan_penerima"],
    catatanKurir: json["catatan_kurir"],
  );
}