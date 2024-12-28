import 'package:latlong2/latlong.dart';

class TrademarkMapModel {
  final int id;
  final String mark;
  final String owner;
  final String address;
  final String status;
  final DateTime filingDate;
  final String filingNumber;
  final String registrationNumber;
  final String imageUrl;
  final double latitude;
  final double longitude;

  LatLng get location => LatLng(latitude, longitude);

  TrademarkMapModel({
    required this.id,
    required this.mark,
    required this.owner,
    required this.address,
    required this.status,
    required this.filingDate,
    required this.filingNumber,
    required this.registrationNumber,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });

  factory TrademarkMapModel.fromJson(Map<String, dynamic> json) {
    return TrademarkMapModel(
      id: json['id'],
      mark: json['mark'] ?? '',
      owner: json['owner'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? '',
      filingDate: DateTime.parse(json['filing_date'] ?? DateTime.now().toIso8601String()),
      filingNumber: json['filing_number'] ?? '',
      registrationNumber: json['registration_number'] ?? '',
      imageUrl: json['image_url'] ?? '',
      latitude: json['coordinates'] != null 
          ? double.parse(json['coordinates']['latitude'].toString())
          : 0.0,
      longitude: json['coordinates'] != null 
          ? double.parse(json['coordinates']['longitude'].toString())
          : 0.0,
    );
  }
}