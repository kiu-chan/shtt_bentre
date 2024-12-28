import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/config/url.dart';

class NewsService {
  static String postUrl = MainUrl.postUrl;
  
  Future<List<Map<String, dynamic>>> fetchNews() async {
    try {
      final response = await http.get(Uri.parse(postUrl));
      
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
      final response = await http.get(Uri.parse('$postUrl/$id'));
      
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