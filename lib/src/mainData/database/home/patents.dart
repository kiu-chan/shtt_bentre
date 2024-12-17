import 'dart:convert';
import 'package:http/http.dart' as http;

class PatentsDatabase {
  static const String baseUrl = 'https://shttbentre.girc.edu.vn/api';

  Future<Map<String, dynamic>> fetchPatentDetail(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patents/$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Không thể tải thông tin chi tiết sáng chế');
      }
    } catch (e) {
      throw Exception('Không thể tải thông tin chi tiết sáng chế');
    }
  }
}