import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/home/trademark.dart';
import 'package:shtt_bentre/src/mainData/data/home/trademark_detail.dart';

class TrademarkService {
  static String baseUrl = MainUrl.trademarksUrl;

  Future<List<TrademarkModel>> fetchTrademarks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Check if response has success status and data is a list
        if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => TrademarkModel.fromJson(json)).toList();
        }
        
        throw Exception('Invalid response format: ${jsonResponse.toString()}');
      }
      
      throw Exception('Failed to load trademarks: ${response.statusCode}');
    } catch (e) {
      print('Error in fetchTrademarks: ${e.toString()}');
      throw Exception('Error fetching trademarks: $e');
    }
  }

  Future<TrademarkDetailModel> fetchTrademarkDetail(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Print response for debugging
        print('API Response: $jsonResponse');
        
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          return TrademarkDetailModel.fromJson(jsonResponse['data']);
        }
        
        throw Exception('Invalid response format: ${jsonResponse.toString()}');
      }
      
      throw Exception('Failed to load trademark detail: ${response.statusCode}');
    } catch (e) {
      print('Error in fetchTrademarkDetail: ${e.toString()}');
      throw Exception('Error fetching trademark detail: $e');
    }
  }
}