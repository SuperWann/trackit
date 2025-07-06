class StatusPaketModel {
  final int idStatusPaket;
  final String statusPaket;

  StatusPaketModel(this.idStatusPaket, this.statusPaket);

  factory StatusPaketModel.fromJson(Map<String, dynamic> json) {
    return StatusPaketModel(json['id_status'], json['nama_status']);
  }
}
