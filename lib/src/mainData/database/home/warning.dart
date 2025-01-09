import 'dart:convert';

import 'package:shtt_bentre/src/mainData/data/home/warning.dart';
import 'package:http/http.dart' as http;

class WarningDatabase {
  Future<List<WarningModel>> fetchWarnings() async {
    try {
      final response = await http.get(
        Uri.parse('https://shttbentre.girc.edu.vn/api/alerts'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => WarningModel.fromJson(json)).toList();
        }
        throw Exception('Dữ liệu không hợp lệ');
      }
      throw Exception('Không thể tải danh sách cảnh báo');
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  Future<WarningModel> fetchWarningDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse('https://shttbentre.girc.edu.vn/api/alerts/$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] != null) {
          return WarningModel.fromJson(jsonResponse['data']);
        }
        throw Exception('Dữ liệu không hợp lệ');
      }
      throw Exception('Không thể tải thông tin chi tiết');
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }
}