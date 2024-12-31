import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/home/trademark/trademark.dart';
import 'package:shtt_bentre/src/mainData/data/home/trademark/trademark_detail.dart';

class TrademarkService {
  static String baseUrl = MainUrl.trademarksUrl;

  Future<List<TrademarkModel>> fetchTrademarks({int page = 1, String? search}) async {
    try {
      var queryParams = <String, String>{
        'page': page.toString(),
      };
      
      if (search != null && search.isNotEmpty) {
        final markResults = await _fetchWithParams({
          ...queryParams,
          'mark': search,
        });
        
        final ownerResults = await _fetchWithParams({
          ...queryParams,
          'owner': search,
        });
        
        final combinedResults = [...markResults, ...ownerResults];
        final uniqueResults = combinedResults.toSet().toList();
        return uniqueResults;
      }

      return _fetchWithParams(queryParams);
    } catch (e) {
      print('Error in fetchTrademarks: ${e.toString()}');
      throw Exception('Error fetching trademarks: $e');
    }
  }

  Future<List<TrademarkModel>> _fetchWithParams(Map<String, String> params) async {
    try {
      final uri = Uri.parse(baseUrl).replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => TrademarkModel.fromJson(json)).toList();
        }
        
        if (jsonResponse['data'] == null) {
          return [];
        }
        
        throw Exception('Invalid response format: ${jsonResponse.toString()}');
      }
      
      throw Exception('Failed to load trademarks: ${response.statusCode}');
    } catch (e) {
      print('Error in _fetchWithParams: ${e.toString()}');
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
      print('Error in fetchTrademarkDetail: ${e.toString()}');
      throw Exception('Error fetching trademark detail: $e');
    }
  }
}