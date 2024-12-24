import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/data/home/trademark.dart';
import 'package:shtt_bentre/src/mainData/data/home/trademark_detail.dart';

class TrademarkService {
  static const String baseUrl = 'https://shttbentre.girc.edu.vn/api/trademarks';

  Future<List<TrademarkModel>> fetchTrademarks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => TrademarkModel.fromJson(json)).toList();
        }
        throw Exception('Invalid data format');
      } else {
        throw Exception('Failed to load trademarks');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<TrademarkDetailModel> fetchTrademarkDetail(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          return TrademarkDetailModel.fromJson(jsonResponse['data']);
        }
        throw Exception('Invalid detail data format');
      } else {
        throw Exception('Failed to load trademark detail');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}