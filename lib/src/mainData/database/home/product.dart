// product.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/home/product/product.dart';

class ProductRegistrationService {
  static String baseUrl = MainUrl.productsUrl;
  
  Future<List<ProductRegistrationModel>> fetchProducts({
    int page = 1,
    String? year,
    String? district,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
      };
      
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
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => ProductRegistrationModel.fromJson(json)).toList();
        }
        throw Exception('Invalid data format');
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> fetchProductDetail(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        return jsonResponse['data'];
      }
      throw Exception('Invalid data format');
    }
    throw Exception('Failed to load product detail');
  }
    Future<List<String>> fetchAvailableYears() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats/by-year'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data
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

  Future<List<Map<String, dynamic>>> fetchAvailableDistricts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats/by-district'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
          return List<Map<String, dynamic>>.from(jsonResponse['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching districts: $e');
      return [];
    }
  }
}