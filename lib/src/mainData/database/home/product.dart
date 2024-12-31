// product.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/home/product/product.dart';

class ProductRegistrationService {
  static String baseUrl = MainUrl.productsUrl;
  
  Future<List<ProductRegistrationModel>> fetchProducts({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?page=$page'),
      );

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
}