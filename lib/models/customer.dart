class CustomerModel {
  int? id;
  final String nama;
  final String noTelepon;
  final String pin;
  final String kecamatan;
  final String kabupaten;
  final String? detailAlamat;

  CustomerModel({
    required this.id,
    required this.nama,
    required this.noTelepon,
    required this.pin,
    required this.kecamatan,
    required this.kabupaten,
    this.detailAlamat,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      nama: json['nama'],
      noTelepon: json['no_telepon'],
      pin: json['pin'],
      kecamatan: json['kecamatan'],
      kabupaten: json['kabupaten'],
      detailAlamat: json['detail_alamat'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id_customer': id,
      'nama_customer': nama,
      'no_telepon': noTelepon,
      'pin': pin,
      'nama_kecamatan': kecamatan,
      'nama_kabupaten': kabupaten,
    };
  }
}
