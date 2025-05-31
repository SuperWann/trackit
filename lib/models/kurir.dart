class KurirModel {
  final int idKurir;
  final String nama;
  final int idKecamatan;

  KurirModel({
    required this.idKurir,
    required this.nama,
    required this.idKecamatan,
  });

  factory KurirModel.fromJson(Map<String, dynamic> json) {
    return KurirModel(
      idKurir: json['id_kurir'] as int,
      nama: json['nama'] as String,
      idKecamatan: json['id_kecamatan'] as int,
    );
  }
}