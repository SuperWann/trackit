import 'package:flutter/foundation.dart';

class PegawaiModel {
  final int id;
  final String nama;
  final String email;
  final String password;
  final String kecamatan;
  final String kabupaten;
  final String peran;

  PegawaiModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.password,
    required this.kecamatan,
    required this.kabupaten,
    required this.peran,
  });

  factory PegawaiModel.fromJson(Map<String, dynamic> json) {
    return PegawaiModel(
      id: json['id'],
      nama: json['nama'],
      email: json['email'],
      password: json['password'],
      peran: json['role'],
      kecamatan: json['kecamatan'],
      kabupaten: json['kabupaten'],
    );
  }

  
}