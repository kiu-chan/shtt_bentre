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
    int page = 1,  // Add page parameter
  }) async {
    try {
      List<ResearchProjectModel> results = [];
      Set<String> uniqueIds = {};

      if (search != null && search.isNotEmpty) {
        // Search by project name
        final queryParamsName = {
          'name': search,
          'page': page.toString(),
          if (type != null) 'type': type,
          if (year != null) 'year': year,
        };
        final responseByName = await _fetchWithParams(queryParamsName);
        for (var project in responseByName) {
          if (uniqueIds.add(project.id)) {
            results.add(project);
          }
        }

        // Search by type
        final queryParamsType = {
          'type': search,
          'page': page.toString(),
          if (year != null) 'year': year,
        };
        final responseByType = await _fetchWithParams(queryParamsType);
        for (var project in responseByType) {
          if (uniqueIds.add(project.id)) {
            results.add(project);
          }
        }

        // Search by leader name
        final queryParamsLeader = {
          'leader_name': search,
          'page': page.toString(),
          if (type != null) 'type': type,
          if (year != null) 'year': year,
        };
        final responseByLeader = await _fetchWithParams(queryParamsLeader);
        for (var project in responseByLeader) {
          if (uniqueIds.add(project.id)) {
            results.add(project);
          }
        }

        // Search by institution
        final queryParamsInstitution = {
          'institution': search,
          'page': page.toString(),
          if (type != null) 'type': type,
          if (year != null) 'year': year,
        };
        final responseByInstitution = await _fetchWithParams(queryParamsInstitution);
        for (var project in responseByInstitution) {
          if (uniqueIds.add(project.id)) {
            results.add(project);
          }
        }

        // Search by year
        if (RegExp(r'^\d{4}$').hasMatch(search)) {
          final queryParamsYear = {
            'year': search,
            'page': page.toString(),
            if (type != null) 'type': type,
          };
          final responseByYear = await _fetchWithParams(queryParamsYear);
          for (var project in responseByYear) {
            if (uniqueIds.add(project.id)) {
              results.add(project);
            }
          }
        }

        return results;
      } else {
        // If no search term, just apply filters and pagination
        final queryParams = <String, String>{
          'page': page.toString(),
        };
        if (type != null) queryParams['type'] = type;
        if (year != null) queryParams['year'] = year;
        
        return await _fetchWithParams(queryParams);
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ResearchProjectModel>> _fetchWithParams(Map<String, String> params) async {
    try {
      final uri = Uri.parse(scienceInnovationsUrl).replace(queryParameters: params);
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
      throw Exception('Failed to load research projects');
    } catch (e) {
      print('Error in _fetchWithParams: $e');
      return [];
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
            ..sort((a, b) => b.compareTo(a));
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