import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/home/industrial_design.dart';
import 'package:shtt_bentre/src/mainData/data/home/industrial_design_detail.dart';

class IndustrialDesignService {
  static String industrialDesignUrl = MainUrl.industrialDesignUrl;

  Future<List<IndustrialDesignModel>> fetchIndustrialDesigns() async {
    try {
      final response = await http.get(
        Uri.parse(industrialDesignUrl),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => IndustrialDesignModel.fromJson(json)).toList();
        }
        throw Exception('Invalid data format');
      } else {
        throw Exception('Failed to load industrial designs');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<IndustrialDesignDetailModel> fetchIndustrialDesignDetail(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$industrialDesignUrl/$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          return IndustrialDesignDetailModel.fromJson(jsonResponse['data']);
        }
        throw Exception('Invalid detail data format');
      } else {
        throw Exception('Failed to load industrial design detail');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}