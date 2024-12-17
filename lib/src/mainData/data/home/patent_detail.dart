import 'dart:convert';
import 'package:http/http.dart' as http;

class PatentDetailModel {
  final String id;
  final String type;
  final String title;
  final String field;
  final String ipcClasses;
  final String owner;
  final String ownerAddress;
  final String inventor;
  final String inventorAddress;
  final String otherInventor;
  final String abstract;
  final String status;
  final String filingNumber;
  final DateTime filingDate;
  final String publicationNumber;
  final DateTime publicationDate;
  final String registrationNumber;
  final List<String> images;

  PatentDetailModel({
    required this.id,
    required this.type,
    required this.title,
    required this.field,
    required this.ipcClasses,
    required this.owner,
    required this.ownerAddress,
    required this.inventor,
    required this.inventorAddress,
    required this.otherInventor,
    required this.abstract,
    required this.status,
    required this.filingNumber,
    required this.filingDate,
    required this.publicationNumber,
    required this.publicationDate,
    required this.registrationNumber,
    required this.images,
  });

  factory PatentDetailModel.fromJson(Map<String, dynamic> json) {
    return PatentDetailModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      field: json['type'] ?? '',
      ipcClasses: json['ipc_classes'] ?? '',
      owner: json['applicant'] ?? '',
      ownerAddress: json['applicant_address'] ?? '',
      inventor: json['inventor'] ?? '',
      inventorAddress: json['inventor_address'] ?? '',
      otherInventor: json['other_inventor'] ?? '',
      abstract: json['abstract'] ?? '',
      status: json['status'] ?? '',
      filingNumber: json['filing_number'] ?? '',
      filingDate: _parseDate(json['filing_date']),
      publicationNumber: json['publication_number'] ?? '',
      publicationDate: _parseDate(json['publication_date']),
      registrationNumber: json['registration_number'] ?? '',
      images: _parseImages(json['images']),
    );
  }

  static DateTime _parseDate(String? dateStr) {
    if (dateStr == null) return DateTime.now();
    try {
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
      return DateTime.now();
    }
  }

  static List<String> _parseImages(dynamic images) {
    if (images is List) {
      return images.map((image) => image['file_url']?.toString() ?? '').toList();
    }
    return [];
  }
}

class PatentDetailService {
  static const String baseUrl = 'https://shttbentre.girc.edu.vn/api/patents';

  Future<PatentDetailModel> getPatentDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final data = jsonResponse['data'];
      return PatentDetailModel.fromJson(data);
    } else {
      throw Exception('Không thể tải thông tin chi tiết sáng chế');
    }
  }
}