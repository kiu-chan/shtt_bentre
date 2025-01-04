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
  }) async {
    try {
      List<TechnicalCompetitionModel> results = [];
      Set<int> uniqueIds = {};

      if (search != null && search.isNotEmpty) {
        // Tìm theo tên dự án
        final resultsByName = await _fetchWithParams({'name': search});
        for (var competition in resultsByName) {
          if (uniqueIds.add(competition.id)) {
            results.add(competition);
          }
        }

        // Tìm theo đơn vị
        final resultsByUnit = await _fetchWithParams({'unit_name': search});
        for (var competition in resultsByUnit) {
          if (uniqueIds.add(competition.id)) {
            results.add(competition);
          }
        }

        // Tìm theo lĩnh vực
        final resultsByField = await _fetchWithParams({'field': search});
        for (var competition in resultsByField) {
          if (uniqueIds.add(competition.id)) {
            results.add(competition);
          }
        }

        // Tìm theo năm nếu search là số
        if (RegExp(r'^\d{4}$').hasMatch(search)) {
          final resultsByYear = await _fetchWithParams({'year': search});
          for (var competition in resultsByYear) {
            if (uniqueIds.add(competition.id)) {
              results.add(competition);
            }
          }
        }

        // Tìm theo submission_date nếu là định dạng ngày
        if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(search)) {
          final resultsByDate = await _fetchWithParams({'submission_date': search});
          for (var competition in resultsByDate) {
            if (uniqueIds.add(competition.id)) {
              results.add(competition);
            }
          }
        }

        // Tìm theo giải thưởng
        final resultsByRank = await _fetchWithParams({'rank': search.toLowerCase()});
        for (var competition in resultsByRank) {
          if (uniqueIds.add(competition.id)) {
            results.add(competition);
          }
        }

      } else {
        // Nếu không có search term, chỉ áp dụng các bộ lọc
        var queryParams = <String, String>{};
        if (field != null) queryParams['field'] = field;
        if (year != null) queryParams['year'] = year;
        if (rank != null) queryParams['rank'] = rank.toLowerCase();
        
        results = await _fetchWithParams(queryParams);
      }

      // Nếu có kết quả search và có bộ lọc, thực hiện lọc thêm
      if (results.isNotEmpty && (field != null || year != null || rank != null)) {
        if (field != null) {
          results = results.where((item) => item.field == field).toList();
        }
        if (year != null) {
          results = results.where((item) => item.year.toString() == year).toList();
        }
        if (rank != null) {
          results = results.where((item) => 
            item.rank.toLowerCase() == rank.toLowerCase()
          ).toList();
        }
      }

      return results;

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