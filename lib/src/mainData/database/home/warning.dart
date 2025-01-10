import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/data/home/warning.dart';

class WarningDatabase {
  Future<List<WarningModel>> fetchWarnings({
    String? search,
    String? status,
    String? assetType,
    String? type
  }) async {
    try {
      // Xây dựng query parameters
      final queryParams = <String, String>{};
      if (search != null && search.isNotEmpty) {
        queryParams['title'] = search;
      }
      if (status != null) queryParams['status'] = status;
      if (assetType != null) queryParams['asset_type'] = assetType;
      if (type != null) queryParams['type'] = type;

      // Tạo URL với query parameters
      final uri = Uri.parse('https://shttbentre.girc.edu.vn/api/alerts')
          .replace(queryParameters: queryParams);

      print('Fetching URL: $uri'); // For debugging

      final response = await http.get(uri);

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
      print('Error in fetchWarnings: $e'); // For debugging
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