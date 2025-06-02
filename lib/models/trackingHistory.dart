class TrackingHistoryModel{
  final DateTime timestamp;
  final String deskripsi;

  TrackingHistoryModel({required this.timestamp, required this.deskripsi});

  factory TrackingHistoryModel.fromJson(Map<String, dynamic> json) {
    return TrackingHistoryModel(timestamp: DateTime.parse(json['timestamp']), deskripsi: json['deskripsi']);
  }
}