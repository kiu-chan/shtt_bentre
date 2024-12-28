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

  static String storageUrl = MainUrl.storageUrl;

  factory TrademarkDetailModel.fromJson(Map<String, dynamic> json) {
    return TrademarkDetailModel(
      id: json['id'] ?? 0,
      filingNumber: json['filing_number'] ?? '',
      publicationNumber: json['publication_number'] ?? '',
      registrationNumber: json['registration_number'] ?? '',
      mark: json['mark'] ?? '',
      markFeature: json['mark_feature'],
      markColors: json['mark_colors'],
      viennaClasses: json['vienna_classes'] ?? '',
      disclaimer: json['disclaimer'],
      owner: json['owner'] ?? '',
      address: json['address'] ?? '',
      filingDate: _parseDate(json['filing_date']),
      registrationDate: _parseDate(json['registration_date']),
      publicationDate: _parseDate(json['publication_date']),
      expirationDate: _parseDate(json['expiration_date']),
      status: json['status'] ?? '',
      imageUrl: json['image_url'] != null 
          ? '$storageUrl/${json['image_url']}' 
          : '',
      type: json['type']?['slug'] ?? '',
      typeName: json['type']?['name'] ?? '',
      representativeName: json['representative_name'] ?? '',
      representativeAddress: json['representative_address'] ?? '',
    );
  }

  static DateTime _parseDate(String? dateStr) {
    if (dateStr == null) return DateTime.now();
    try {
      // Parse date format "dd.MM.yyyy"
      final parts = dateStr.split('.');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
      return DateTime.parse(dateStr);
    } catch (e) {
      print('Error parsing date: $dateStr');
      return DateTime.now();
    }
  }
}