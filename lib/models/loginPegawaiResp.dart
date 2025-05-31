import 'package:trackit_dev/models/pegawai.dart';

class LoginPegawaiResponseModel {
  final String token;
  final PegawaiModel pegawai;

  LoginPegawaiResponseModel({
    required this.token,
    required this.pegawai,
  });

  factory LoginPegawaiResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginPegawaiResponseModel(
      token: json['token'],
      pegawai: PegawaiModel.fromJson(json['pegawai']),
    );
  }
}