class KabupatenModel {
  int? idKabupaten;
  String? namaKabupaten;

  KabupatenModel({this.idKabupaten, this.namaKabupaten});

  KabupatenModel.fromJson(Map<String, dynamic> json) {
    idKabupaten = json['id_kabupaten'];
    namaKabupaten = json['nama_kabupaten'];
  }
} 
