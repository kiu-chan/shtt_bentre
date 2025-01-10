import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/home/initiative/initiative.dart';

class InitiativeService {
  static String initiativeUrl = MainUrl.initiativeUrl;

  Future<List<InitiativeModel>> fetchInitiatives({
    String? search,
    String? year,
    int page = 1,  // Add page parameter
  }) async {
    try {
      List<InitiativeModel> results = [];
      Set<String> uniqueIds = {};

      if (search != null && search.isNotEmpty) {
        // Search by name
        final resultsByName = await _fetchWithParams({
          'name': search,
          'page': page.toString(),
          if (year != null) 'recognition_year': year
        });
        for (var initiative in resultsByName) {
          if (uniqueIds.add(initiative.id)) {
            results.add(initiative);
          }
        }

        // Search by author
        final resultsByAuthor = await _fetchWithParams({
          'author': search,
          'page': page.toString(),
          if (year != null) 'recognition_year': year
        });
        for (var initiative in resultsByAuthor) {
          if (uniqueIds.add(initiative.id)) {
            results.add(initiative);
          }
        }

        // Search by owner
        final resultsByOwner = await _fetchWithParams({
          'owner': search,
          'page': page.toString(),
          if (year != null) 'recognition_year': year
        });
        for (var initiative in resultsByOwner) {
          if (uniqueIds.add(initiative.id)) {
            results.add(initiative);
          }
        }

        // Search by address
        final resultsByAddress = await _fetchWithParams({
          'address': search,
          'page': page.toString(),
          if (year != null) 'recognition_year': year
        });
        for (var initiative in resultsByAddress) {
          if (uniqueIds.add(initiative.id)) {
            results.add(initiative);
          }
        }

        return results;
      } else {
        // If no search term, just apply year filter and pagination
        return await _fetchWithParams({
          'page': page.toString(),
          if (year != null) 'recognition_year': year
        });
      }
    } catch (e) {
      print('Error in fetchInitiatives: $e');
      throw Exception('Failed to load initiatives: $e');
    }
  }

  Future<List<InitiativeModel>> _fetchWithParams(Map<String, String> params) async {
    try {
      final uri = Uri.parse(initiativeUrl).replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => InitiativeModel.fromJson(json)).toList();
        }
        return [];
      }
      throw Exception('Failed to load initiatives: ${response.statusCode}');
    } catch (e) {
      print('Error in _fetchWithParams: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchInitiativeDetail(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$initiativeUrl/$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          return jsonResponse['data'];
        }
        throw Exception('Invalid detail data format');
      }
      throw Exception('Failed to load initiative detail');
    } catch (e) {
      print('Error fetching initiative detail: $e');
      throw Exception('Error: $e');
    }
  }

  Future<List<String>> fetchAvailableYears() async {
    try {
      final response = await http.get(
        Uri.parse('$initiativeUrl/stats/by-year'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data
              .map((year) => year['year'].toString())
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

  Future<List<Map<String, dynamic>>> fetchInitiativesByField() async {
    try {
      final response = await http.get(
        Uri.parse('$initiativeUrl/stats/by-field'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] is List) {
          return List<Map<String, dynamic>>.from(jsonResponse['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching fields stats: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchInitiativesByStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$initiativeUrl/stats/by-status'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] is List) {
          return List<Map<String, dynamic>>.from(jsonResponse['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching status stats: $e');
      return [];
    }
  }
}