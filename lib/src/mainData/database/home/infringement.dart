// lib/src/mainData/database/infringement.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/data/home/infringement.dart';

class InfringementService {
  static const String baseUrl = 'https://shttbentre.girc.edu.vn/api/infringements';

  Future<List<InfringementModel>> fetchInfringements({
    String? search,
    String? status,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (search != null && search.isNotEmpty) {
        queryParams['name'] = search;
      }
      if (status != null) {
        queryParams['status'] = status;
      }

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => InfringementModel.fromJson(json)).toList();
        }
        return [];
      }
      throw Exception('Failed to load infringements: ${response.statusCode}');
    } catch (e) {
      print('Error fetching infringements: $e');
      throw Exception('Error: $e');
    }
  }

  Future<InfringementModel> fetchInfringementDetail(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          return InfringementModel.fromJson(jsonResponse['data']);
        }
        throw Exception('Dữ liệu không hợp lệ');
      }
      throw Exception('Failed to load infringement detail: ${response.statusCode}');
    } catch (e) {
      print('Error fetching infringement detail: $e');
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, int>> fetchStatusStats() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/stats/by-status'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
          final stats = <String, int>{};
          for (var item in jsonResponse['data']) {
            stats[item['status']] = item['count'];
          }
          return stats;
        }
      }
      return {};
    } catch (e) {
      print('Error fetching status stats: $e');
      return {};
    }
  }
}