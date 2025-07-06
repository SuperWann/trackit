class RegistrasiCustomer {
  final String telepon;
  final String pin;
  String? nama;
  String? detailAlamat;
  int? idKecamatan;

  RegistrasiCustomer({
    this.nama,
    this.detailAlamat,
    this.idKecamatan,
    required this.telepon,
    required this.pin,
  });

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'no_telepon': telepon,
    'pin': pin,
    'id_kecamatan': idKecamatan,
    'detail_alamat': detailAlamat,
  };
}
