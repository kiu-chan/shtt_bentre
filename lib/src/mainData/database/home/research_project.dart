// research_project_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/data/home/research_project.dart';

class ResearchProjectService {
  static const String baseUrl = 'https://shttbentre.girc.edu.vn/api';

  Future<List<ResearchProjectModel>> fetchResearchProjects() async {
    final response = await http.get(Uri.parse('$baseUrl/science-innovations'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == 'success' && jsonData['data'] is List) {
        return (jsonData['data'] as List)
            .map((json) => ResearchProjectModel.fromJson(json))
            .toList();
      }
    }
    throw Exception('Failed to load research projects');
  }

    Future<ResearchProjectModel> fetchResearchProjectDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/science-innovations/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == 'success' && jsonData['data'] != null) {
        return ResearchProjectModel.fromJson(jsonData['data']);
      }
    }
    throw Exception('Failed to load research project detail');
  }
}