import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/data/home/patent.dart';

class PatentsDatabase {
  static const String baseUrl = 'https://shttbentre.girc.edu.vn/api';

    Future<List<PatentModel>> fetchPatents() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'] ?? [];
        
        return data.map((json) => PatentModel.fromJson(json)).toList();
      } else {
        throw Exception('Không thể tải dữ liệu sáng chế');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

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