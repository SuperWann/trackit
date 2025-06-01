class Coordinate {
  final double longitude;
  final double latitude;

  Coordinate({required this.longitude, required this.latitude});

  factory Coordinate.fromJson(Map<String, dynamic> json) {
    return Coordinate(longitude: json['longitude'], latitude: json['latitude']);
  }
}

class CoordinatePointModel {
  final List<Coordinate> pengirim;
  final List<Coordinate> penerima;

  CoordinatePointModel({required this.pengirim, required this.penerima});

  factory CoordinatePointModel.fromJson(Map<String, dynamic> json) {
    var pengirimList =
        (json['pengirim'] as List).map((e) => Coordinate.fromJson(e)).toList();

    var penerimaList =
        (json['penerima'] as List).map((e) => Coordinate.fromJson(e)).toList();

    return CoordinatePointModel(pengirim: pengirimList, penerima: penerimaList);
  }
}
