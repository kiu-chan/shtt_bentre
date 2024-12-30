// trademark_detail_model.dart
import 'package:shtt_bentre/src/mainData/config/url.dart';

class TrademarkDetailModel {
  final int id;
  final String filingNumber;
  final String publicationNumber;
  final String registrationNumber;
  final String mark;
  final String? markFeature;
  final String? markColors;
  final String viennaClasses;
  final String? disclaimer;
  final String owner;
  final String address;
  final DateTime filingDate;
  final DateTime registrationDate;
  final DateTime publicationDate;
  final DateTime expirationDate;
  final String status;
  final String imageUrl;
  final String type;
  final String typeName;
  final String representativeName;
  final String representativeAddress;

  TrademarkDetailModel({
    required this.id,
    required this.filingNumber,
    required this.publicationNumber,
    required this.registrationNumber,
    required this.mark,
    this.markFeature,
    this.markColors,
    required this.viennaClasses,
    this.disclaimer,
    required this.owner,
    required this.address,
    required this.filingDate,
    required this.registrationDate,
    required this.publicationDate,
    required this.expirationDate,
    required this.status,
    required this.imageUrl,
    required this.type,
    required this.typeName,
    required this.representativeName,
    required this.representativeAddress,
  });

  factory TrademarkDetailModel.fromJson(Map<String, dynamic> json) {
    try {
      return TrademarkDetailModel(
        id: json['id'] ?? 0,
        filingNumber: json['filing_number']?.toString() ?? '',
        publicationNumber: json['publication_number']?.toString() ?? '',
        registrationNumber: json['registration_number']?.toString() ?? '',
        mark: json['mark']?.toString() ?? '',
        markFeature: json['mark_feature']?.toString(),
        markColors: json['mark_colors']?.toString(),
        viennaClasses: json['vienna_classes']?.toString() ?? '',
        disclaimer: json['disclaimer']?.toString(),
        owner: json['owner']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        filingDate: _parseDate(json['filing_date']),
        registrationDate: _parseDate(json['registration_date']),
        publicationDate: _parseDate(json['publication_date']),
        expirationDate: _parseDate(json['expiration_date']),
        status: json['status']?.toString() ?? '',
        imageUrl: json['image_url']?.toString() ?? '',
        type: json['type']?.toString() ?? '',
        typeName: json['type_name']?.toString() ?? '',
        representativeName: json['representative_name']?.toString() ?? '',
        representativeAddress: json['representative_address']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing TrademarkDetailModel: $e');
      print('Input JSON: $json');
      rethrow;
    }
  }

  static DateTime _parseDate(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    
    try {
      if (dateValue is String) {
        // Handle string date formats
        if (dateValue.contains('T')) {
          return DateTime.parse(dateValue);
        }
        
        // Handle dd.MM.yyyy format
        final parts = dateValue.split('.');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]), // year
            int.parse(parts[1]), // month
            int.parse(parts[0]), // day
          );
        }
      }
      
      return DateTime.now();
    } catch (e) {
      print('Error parsing date: $dateValue - ${e.toString()}');
      return DateTime.now();
    }
  }
}