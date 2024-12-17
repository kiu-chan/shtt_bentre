import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/data/home/initiative.dart';

class InitiativeService {
  static const String baseUrl = 'https://shttbentre.girc.edu.vn/api';

  Future<List<InitiativeModel>> fetchInitiatives() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/initiatives'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data']['data'];
        return data.map((json) => InitiativeModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load initiatives');
      }
    } catch (e) {
      throw Exception('Failed to load initiatives: $e');
    }
  }

    Future<Map<String, dynamic>> fetchInitiativeDetail(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/initiatives/$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Không thể tải thông tin chi tiết sáng kiến');
      }
    } catch (e) {
      throw Exception('Không thể tải thông tin chi tiết sáng kiến');
    }
  }
}