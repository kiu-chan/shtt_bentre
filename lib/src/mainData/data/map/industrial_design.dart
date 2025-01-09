import 'package:latlong2/latlong.dart';

class IndustrialDesignMapModel {
  final int id;
  final double latitude;
  final double longitude;

  LatLng get location => LatLng(latitude, longitude);

  IndustrialDesignMapModel({
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  factory IndustrialDesignMapModel.fromJson(Map<String, dynamic> json) {
    try {
      String? geomText = json['coordinates'].toString();
      if (geomText.startsWith('POINT(')) {
        geomText = geomText.replaceAll('POINT(', '').replaceAll(')', '');
        final coords = geomText.split(' ');
        if (coords.length == 2) {
          return IndustrialDesignMapModel(
            id: json['id'] as int,
            longitude: double.parse(coords[0]),
            latitude: double.parse(coords[1]),
          );
        }
      }
      
      // Fallback for when coordinates are directly provided in the JSON
      return IndustrialDesignMapModel(
        id: json['id'] as int,
        latitude: json['coordinates'] != null 
            ? double.parse(json['coordinates']['latitude'].toString())
            : 0.0,
        longitude: json['coordinates'] != null 
            ? double.parse(json['coordinates']['longitude'].toString())
            : 0.0,
      );
    } catch (e) {
      print('Error parsing industrial design data: $e');
      print('Raw JSON: $json');
      rethrow;
    }
  }
}