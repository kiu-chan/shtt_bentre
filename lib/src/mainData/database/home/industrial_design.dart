import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/home/industrial_design.dart';
import 'package:shtt_bentre/src/mainData/data/home/industrial_design_detail.dart';
import 'package:shtt_bentre/src/mainData/database/database_exception.dart';

class IndustrialDesignService {
  static String industrialDesignUrl = MainUrl.industrialDesignUrl;

  Future<List<IndustrialDesignModel>> fetchIndustrialDesigns() async {
    print(industrialDesignUrl);
    try {
      final response = await http.get(
        Uri.parse(industrialDesignUrl),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw DatabaseException('Timeout when fetching industrial designs');
        },
      );

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          
          if (jsonResponse['status'] != 'success') {
            throw DatabaseException('API returned unsuccessful status: ${jsonResponse['status']}');
          }
          
          if (jsonResponse['data'] == null) {
            throw DatabaseException('API returned null data');
          }
          
          if (jsonResponse['data'] is! List) {
            throw DatabaseException('API returned invalid data format: expected List but got ${jsonResponse['data'].runtimeType}');
          }

          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) {
            try {
              return IndustrialDesignModel.fromJson(json);
            } catch (e) {
              throw DatabaseException('Error parsing industrial design: $e');
            }
          }).toList();
        } on FormatException catch (e) {
          throw DatabaseException('Invalid JSON format: $e');
        }
      } else if (response.statusCode == 404) {
        throw DatabaseException('Industrial designs endpoint not found');
      } else if (response.statusCode >= 500) {
        throw DatabaseException('Server error: ${response.statusCode}');
      } else {
        throw DatabaseException('Failed to load industrial designs: ${response.statusCode}');
      }
    } on SocketException {
      throw DatabaseException('No internet connection');
    } catch (e) {
      if (e is DatabaseException) rethrow;
      throw DatabaseException('Unexpected error: $e');
    }
  }

  Future<IndustrialDesignDetailModel> fetchIndustrialDesignDetail(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$industrialDesignUrl/$id'),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw DatabaseException('Timeout when fetching industrial design detail');
        },
      );

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          
          if (jsonResponse['status'] != 'success') {
            throw DatabaseException('API returned unsuccessful status: ${jsonResponse['status']}');
          }
          
          if (jsonResponse['data'] == null) {
            throw DatabaseException('API returned null data');
          }

          return IndustrialDesignDetailModel.fromJson(jsonResponse['data']);
        } on FormatException catch (e) {
          throw DatabaseException('Invalid JSON format: $e');
        }
      } else if (response.statusCode == 404) {
        throw DatabaseException('Industrial design with ID $id not found');
      } else if (response.statusCode >= 500) {
        throw DatabaseException('Server error: ${response.statusCode}');
      } else {
        throw DatabaseException('Failed to load industrial design detail: ${response.statusCode}');
      }
    } on SocketException {
      throw DatabaseException('No internet connection');
    } catch (e) {
      if (e is DatabaseException) rethrow;
      throw DatabaseException('Unexpected error: $e');
    }
  }
}