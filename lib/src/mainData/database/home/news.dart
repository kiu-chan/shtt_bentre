import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  static const String baseUrl = 'https://shttbentre.girc.edu.vn/api';
  
  Future<List<Map<String, dynamic>>> fetchNews() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts'));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success' && jsonData['data'] != null) {
          return List<Map<String, dynamic>>.from(jsonData['data']);
        }
      }
      throw Exception('Failed to load news');
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  Future<Map<String, dynamic>> fetchNewsDetail(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts/$id'));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success' && jsonData['data'] != null) {
          return jsonData['data'];
        }
      }
      throw Exception('Failed to load news detail');
    } catch (e) {
      throw Exception('Failed to load news detail: $e');
    }
  }
}