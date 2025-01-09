import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/home/trademark/trademark.dart';
import 'package:shtt_bentre/src/mainData/data/home/trademark/trademark_detail.dart';

class TrademarkService {
  static String baseUrl = MainUrl.trademarksUrl;

  Future<List<Map<String, dynamic>>> fetchTrademarkTypes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats/by-type'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
          return List<Map<String, dynamic>>.from(jsonResponse['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching trademark types: $e');
      return [];
    }
  }

  Future<List<String>> fetchTrademarkYears() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats/by-year'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
          return List<String>.from(
            jsonResponse['data'].map((item) => item['year'].toString()),
          );
        }
      }
      return [];
    } catch (e) {
      print('Error fetching trademark years: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchTrademarkDistricts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats/by-district'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
          return List<Map<String, dynamic>>.from(jsonResponse['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching trademark districts: $e');
      return [];
    }
  }

  Future<List<TrademarkModel>> fetchTrademarks({
    int page = 1,
    String? search,
    String? type,
    String? year,
    String? district,
  }) async {
    try {
      var queryParams = <String, String>{
        'page': page.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (type != null) {
        queryParams['mark'] = type;
      }
      if (year != null) {
        queryParams['year'] = year;
      }
      if (district != null) {
        queryParams['district'] = district;
      }

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => TrademarkModel.fromJson(json)).toList();
        }
        return [];
      }
      throw Exception('Failed to load trademarks: ${response.statusCode}');
    } catch (e) {
      print('Error in fetchTrademarks: $e');
      throw Exception('Error fetching trademarks: $e');
    }
  }

  Future<TrademarkDetailModel> fetchTrademarkDetail(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          return TrademarkDetailModel.fromJson(jsonResponse['data']);
        }
        throw Exception('Invalid response format: ${jsonResponse.toString()}');
      }
      throw Exception('Failed to load trademark detail: ${response.statusCode}');
    } catch (e) {
      print('Error in fetchTrademarkDetail: $e');
      throw Exception('Error fetching trademark detail: $e');
    }
  }
}