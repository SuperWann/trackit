class KecamatanModel {
  int? idKecamatan;
  String? namaKecamatan;

  KecamatanModel({this.idKecamatan, this.namaKecamatan});

  KecamatanModel.fromJson(Map<String, dynamic> json) {
    idKecamatan = json['id_kecamatan'];
    namaKecamatan = json['nama_kecamatan'];
  }
} 
