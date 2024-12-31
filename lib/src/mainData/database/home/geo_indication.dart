// geo_indication.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/home/geoIndication/geo_indication.dart';
import 'package:shtt_bentre/src/mainData/data/home/geoIndication/geo_indication_detail_model.dart';

class GeoIndicationService {
  static String geoIndicationUrl = MainUrl.geoIndicationUrl;

  Future<List<GeoIndicationModel>> fetchGeoIndications({String? search}) async {
    try {
      final Uri uri;
      if (search != null && search.isNotEmpty) {
        uri = Uri.parse(geoIndicationUrl).replace(
          queryParameters: {'search': search},
        );
      } else {
        uri = Uri.parse(geoIndicationUrl);
      }

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => GeoIndicationModel.fromJson(json)).toList();
        }
        throw Exception('Invalid data format');
      } else {
        throw Exception('Failed to load geographical indications');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<GeoIndicationDetailModel> fetchGeoIndicationDetail(int stt) async {
    try {
      final response = await http.get(
        Uri.parse('$geoIndicationUrl/$stt'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          return GeoIndicationDetailModel.fromJson(jsonResponse['data']);
        }
        throw Exception('Invalid detail data format');
      } else {
        throw Exception('Failed to load geographical indication detail');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<String>> fetchAvailableYears() async {
    try {
      final response = await http.get(
        Uri.parse('${MainUrl.geoIndicationUrl}/stats/by-year'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((item) => item['year'].toString()).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching years: $e');
      return [];
    }
  }

  Future<List<GeoIndicationModel>> fetchGeoIndicationsByYear(String year) async {
    try {
      final response = await http.get(
        Uri.parse('${MainUrl.geoIndicationUrl}?year=$year'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => GeoIndicationModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching by year: $e');
      return [];
    }
  }

  // Thêm trong class GeoIndicationService
Future<List<Map<String, dynamic>>> fetchAvailableDistricts() async {
  try {
    final response = await http.get(
      Uri.parse('${MainUrl.geoIndicationUrl}/stats/by-district'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((item) => {
          'id': item['district_id'],
          'name': item['district_name'],
          'count': item['count'],
        }).toList();
      }
    }
    return [];
  } catch (e) {
    print('Error fetching districts: $e');
    return [];
  }
}

Future<List<GeoIndicationModel>> fetchGeoIndicationsByDistrict(String district) async {
  try {
    final encodedDistrict = Uri.encodeComponent(district);
    final response = await http.get(
      Uri.parse('${MainUrl.geoIndicationUrl}?district=$encodedDistrict'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => GeoIndicationModel.fromJson(json)).toList();
      }
    }
    return [];
  } catch (e) {
    print('Error fetching by district: $e');
    return [];
  }
}
}