import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/home/researchProject/research_project.dart';

class ResearchProjectService {
  static String scienceInnovationsUrl = MainUrl.scienceInnovationsUrl;

  Future<List<ResearchProjectModel>> fetchResearchProjects({
    String? search,
    String? type,
    String? year,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (type != null) {
        queryParams['type'] = type;
      }
      if (year != null) {
        queryParams['year'] = year;
      }

      // Create URI with query parameters
      final uri = Uri.parse(scienceInnovationsUrl).replace(
        queryParameters: queryParams,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success' && jsonData['data'] is List) {
          return (jsonData['data'] as List)
              .map((json) => ResearchProjectModel.fromJson(json))
              .toList();
        }
        return [];
      }
      throw Exception('Failed to load research projects: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching research projects: $e');
    }
  }

  Future<List<String>> fetchAvailableFields() async {
    try {
      final response = await http.get(
        Uri.parse('$scienceInnovationsUrl/stats/by-type'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true && jsonData['data'] is List) {
          return (jsonData['data'] as List)
              .map((item) => item['type'].toString())
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching fields: $e');
      return [];
    }
  }

  Future<List<String>> fetchAvailableYears() async {
    try {
      final response = await http.get(
        Uri.parse('$scienceInnovationsUrl/stats/by-year'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true && jsonData['data'] is List) {
          return (jsonData['data'] as List)
              .map((item) => item['year'].toString())
              .toList()
            ..sort((a, b) => b.compareTo(a)); // Sort years in descending order
        }
      }
      return [];
    } catch (e) {
      print('Error fetching years: $e');
      return [];
    }
  }

  Future<ResearchProjectModel> fetchResearchProjectDetail(String id) async {
    final response = await http.get(Uri.parse('$scienceInnovationsUrl/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == 'success' && jsonData['data'] != null) {
        return ResearchProjectModel.fromJson(jsonData['data']);
      }
    }
    throw Exception('Failed to load research project detail');
  }
}