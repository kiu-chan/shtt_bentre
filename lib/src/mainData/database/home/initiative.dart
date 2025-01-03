import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/home/initiative/initiative.dart';

class InitiativeService {
  static String initiativeUrl = MainUrl.initiativeUrl;

  Future<List<String>> fetchAvailableYears() async {
    try {
      final response = await http.get(
        Uri.parse('$initiativeUrl/stats/by-year'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((year) => year['year'].toString()).toList()..sort();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching years: $e');
      return [];
    }
  }

  Future<List<InitiativeModel>> fetchInitiatives({String? year}) async {
    try {
      final Uri uri;
      if (year != null && year.isNotEmpty) {
        uri = Uri.parse(initiativeUrl).replace(
          queryParameters: {'recognition_year': year},
        );
      } else {
        uri = Uri.parse(initiativeUrl);
      }
      print(uri);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
          final List<dynamic> initiatives = jsonResponse['data'];
          return initiatives.map((item) {
            try {
              return InitiativeModel.fromJson(item);
            } catch (e) {
              print('Error parsing initiative: $e');
              print('Initiative data: $item');
              rethrow;
            }
          }).toList();
        }
        return [];
      }
      throw Exception('Failed to load initiatives: ${response.statusCode}');
    } catch (e) {
      print('Error in fetchInitiatives: $e');
      throw Exception('Failed to load initiatives: $e');
    }
  }

  Future<Map<String, dynamic>> fetchInitiativeDetail(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$initiativeUrl/$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      }
      throw Exception('Không thể tải thông tin chi tiết sáng kiến');
    } catch (e) {
      throw Exception('Không thể tải thông tin chi tiết sáng kiến');
    }
  }
}