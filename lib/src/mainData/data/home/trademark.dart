import 'package:shtt_bentre/src/mainData/config/url.dart';

class TrademarkModel {
  final int id;
  final String filingNumber;
  final String mark;
  final String owner;
  final String address;
  final String imageUrl;
  final DateTime filingDate;
  final String status;
  final String type;
  final String typeName;

  TrademarkModel({
    required this.id,
    required this.filingNumber,
    required this.mark,
    required this.owner,
    required this.address,
    required this.imageUrl,
    required this.filingDate,
    required this.status,
    required this.type,
    required this.typeName,
  });

  factory TrademarkModel.fromJson(Map<String, dynamic> json) {

    String storageUrl = MainUrl.storageUrl;

    return TrademarkModel(
      id: json['id'] ?? 0,
      filingNumber: json['filing_number'] ?? '',
      mark: json['mark'] ?? '',
      owner: json['owner'] ?? '',
      address: json['address'] ?? '',
      imageUrl: json['image_url'] != null 
          ? '$storageUrl/${json['image_url']}' 
          : '',
      filingDate: _parseDate(json['filing_date']),
      status: json['status'] ?? '',
      type: json['type']?['slug'] ?? '',
      typeName: json['type']?['name'] ?? '',
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