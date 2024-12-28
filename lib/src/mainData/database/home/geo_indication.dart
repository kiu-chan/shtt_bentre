import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/home/geoIndication/geo_indication.dart';
import 'package:shtt_bentre/src/mainData/data/home/geoIndication/geo_indication_detail_model.dart';

class GeoIndicationService {
  static String geoIndicationUrl = MainUrl.geoIndicationUrl;

  Future<List<GeoIndicationModel>> fetchGeoIndications() async {
    try {
      final response = await http.get(
        Uri.parse(geoIndicationUrl),
      );

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
}
