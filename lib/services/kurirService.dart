import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:trackit_dev/config.dart';
import 'package:trackit_dev/models/UploadFotoBuktiResponse.dart';
import 'package:trackit_dev/models/kurir.dart';
import 'package:trackit_dev/models/listPengirimanKurir.dart';

class KurirService {
  final Dio _dio = Dio();

  final String _baseUrl =
      '${ApiConfig.baseUrl}'
              '/trackit/Kurir'
          .trim();

  Future<List<KurirModel>> getDataKurir(int idKecamatan) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/DataKurir/$idKecamatan'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData.map((json) => KurirModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mendapatkan data kurir: ${response.body}');
    }
  }

  Future<List<ListPengirimanKurirModel>> getDataListPengirimanKurir(
    int idKurir,
  ) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/DataPengiriman/$idKurir'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      // print(jsonData);
      return jsonData
          .map((json) => ListPengirimanKurirModel.fromJson(json))
          .toList();
    } else {
      throw Exception(
        'Gagal mendapatkan data pengiriman kurir: ${response.body}',
      );
    }
  }

  Future<UploadFotoBuktiResponse?> uploadFotoBukti({
    required String noResi,
    required XFile image,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'NoResi': noResi,
        'FotoBukti': await MultipartFile.fromFile(
          image.path,
          filename:
              'foto_bukti_${noResi}_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      Response resp = await _dio.put(
        '$_baseUrl/UpdateFotoBukti',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (resp.statusCode == 200) {
        return UploadFotoBuktiResponse.fromJson(resp.data);
      }
      return null;
    } catch (e) {
      print('Error updating foto bukti: $e');
      return null;
    }
  }
}
