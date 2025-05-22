import 'package:trackit_dev/models/pegawai.dart';

class LoginPegawaiResponse {
  final String token;
  final PegawaiModel pegawai;

  LoginPegawaiResponse({
    required this.token,
    required this.pegawai,
  });

  factory LoginPegawaiResponse.fromJson(Map<String, dynamic> json) {
    return LoginPegawaiResponse(
      token: json['token'],
      pegawai: PegawaiModel.fromJson(json['pegawai']),
    );
  }
}