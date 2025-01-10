import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/home/technicalCompetition/technical_competition.dart';

class TechnicalCompetitionService {
  static String baseUrl = MainUrl.technicalInnovationsUrl;

  Future<List<TechnicalCompetitionModel>> fetchCompetitions({
    String? search,
    String? field,
    String? year,
    String? rank,
    int page = 1,  // Add page parameter
  }) async {
    try {
      List<TechnicalCompetitionModel> results = [];
      Set<int> uniqueIds = {};

      if (search != null && search.isNotEmpty) {
        // Tìm theo tên dự án
        final resultsByName = await _fetchWithParams({
          'name': search,
          'page': page.toString(),
          if (field != null) 'field': field,
          if (year != null) 'year': year,
          if (rank != null) 'rank': rank.toLowerCase(),
        });
        for (var competition in resultsByName) {
          if (uniqueIds.add(competition.id)) {
            results.add(competition);
          }
        }

        // Tìm theo đơn vị
        final resultsByUnit = await _fetchWithParams({
          'unit_name': search,
          'page': page.toString(),
          if (field != null) 'field': field,
          if (year != null) 'year': year,
          if (rank != null) 'rank': rank.toLowerCase(),
        });
        for (var competition in resultsByUnit) {
          if (uniqueIds.add(competition.id)) {
            results.add(competition);
          }
        }

        // Tìm theo lĩnh vực
        final resultsByField = await _fetchWithParams({
          'field': search,
          'page': page.toString(),
          if (year != null) 'year': year,
          if (rank != null) 'rank': rank.toLowerCase(),
        });
        for (var competition in resultsByField) {
          if (uniqueIds.add(competition.id)) {
            results.add(competition);
          }
        }

        // Tìm theo năm nếu search là số
        if (RegExp(r'^\d{4}$').hasMatch(search)) {
          final resultsByYear = await _fetchWithParams({
            'year': search,
            'page': page.toString(),
            if (field != null) 'field': field,
            if (rank != null) 'rank': rank.toLowerCase(),
          });
          for (var competition in resultsByYear) {
            if (uniqueIds.add(competition.id)) {
              results.add(competition);
            }
          }
        }

        // Tìm theo giải thưởng
        final resultsByRank = await _fetchWithParams({
          'rank': search.toLowerCase(),
          'page': page.toString(),
          if (field != null) 'field': field,
          if (year != null) 'year': year,
        });
        for (var competition in resultsByRank) {
          if (uniqueIds.add(competition.id)) {
            results.add(competition);
          }
        }

        return results;
      } else {
        // Nếu không có search term, chỉ áp dụng các bộ lọc và phân trang
        var queryParams = <String, String>{
          'page': page.toString(),
        };
        if (field != null) queryParams['field'] = field;
        if (year != null) queryParams['year'] = year;
        if (rank != null) queryParams['rank'] = rank.toLowerCase();
        
        return await _fetchWithParams(queryParams);
      }
    } catch (e) {
      print('Error fetching competitions: $e');
      rethrow;
    }
  }

  Future<List<TechnicalCompetitionModel>> _fetchWithParams(Map<String, String> params) async {
    try {
      final uri = Uri.parse(baseUrl).replace(queryParameters: params);
      print('Fetching URL: $uri');
      
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => TechnicalCompetitionModel.fromJson(json)).toList();
        }
        return [];
      }
      throw Exception('Failed to load competitions: ${response.statusCode}');
    } catch (e) {
      print('Error in _fetchWithParams: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchCompetitionsByYear() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats/year'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return List<Map<String, dynamic>>.from(data);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching competition years: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchCompetitionsByField() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats/field'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return List<Map<String, dynamic>>.from(data);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching competition fields: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchCompetitionsByRank() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats/rank'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return List<Map<String, dynamic>>.from(data);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching competition ranks: $e');
      return [];
    }
  }
}