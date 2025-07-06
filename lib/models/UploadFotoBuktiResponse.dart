class UploadFotoBuktiResponse {
  final bool success;
  final String message;
  final String? fotoUrl;
  final String noResi;

  UploadFotoBuktiResponse({
    required this.success,
    required this.message,
    this.fotoUrl,
    required this.noResi,
  });

  factory UploadFotoBuktiResponse.fromJson(Map<String, dynamic> json) {
    return UploadFotoBuktiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      fotoUrl: json['fotoUrl'],
      noResi: json['noResi'] ?? '',
    );
  }
}