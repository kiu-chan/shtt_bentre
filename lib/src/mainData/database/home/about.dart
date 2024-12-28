import 'dart:convert';

import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/home/about.dart';
import 'package:http/http.dart' as http;

class AboutData {
  Future<AboutModel> fetchAboutData() async {
    final response = await http.get(
      Uri.parse(MainUrl.aboutsUrl),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == 'success' && jsonData['data'] is List && jsonData['data'].isNotEmpty) {
        return AboutModel.fromJson(jsonData['data'][0]);
      }
      throw Exception('No data found');
    }
    throw Exception('Failed to load about data');
  }
}
