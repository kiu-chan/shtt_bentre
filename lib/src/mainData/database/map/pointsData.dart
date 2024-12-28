import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/patent.dart';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/data/trademark.dart';
import 'package:shtt_bentre/src/mainData/database/database_exception.dart';

class Pointsdata {
  static String baseUrl = MainUrl.apiUrl;
  static String patentLocationsUrl = MainUrl.patentLocationsUrl;
  static String trademarkLocationsUrl = MainUrl.trademarkLocationsUrl;

  Future<List<Patent>> loadPatentData() async {
    try {
      final response = await http.get(Uri.parse(patentLocationsUrl));
      
      if (response.statusCode != 200) {
        print('API Error - Status Code: ${response.statusCode}');
        print('API Response Body: ${response.body}');
        
        // Check if response is HTML (error page)
        if (response.body.trim().toLowerCase().startsWith('<!doctype html>') ||
            response.body.trim().toLowerCase().startsWith('<html')) {
          throw DatabaseException('API endpoint not found. Please check the URL configuration.');
        }
        
        throw DatabaseException('API request failed with status: ${response.statusCode}');
      }

      // Check if response is HTML despite 200 status
      if (response.body.trim().toLowerCase().startsWith('<!doctype html>') ||
          response.body.trim().toLowerCase().startsWith('<html')) {
        throw DatabaseException('Received HTML response instead of JSON. Please check the API endpoint.');
      }

      final data = json.decode(response.body);
      
      if (!data['success']) {
        throw DatabaseException(data['message'] ?? 'Failed to fetch patent data');
      }

      List<Patent> patents = [];
      for (final item in data['data']) {
        try {
          if (item != null && item['coordinates'] != null) {
            final coordinates = item['coordinates'];
            if (coordinates['latitude'] != null && coordinates['longitude'] != null) {
              patents.add(Patent(
                id: item['id'],
                location: LatLng(
                  double.parse(coordinates['latitude'].toString()),
                  double.parse(coordinates['longitude'].toString())
                ),
                districtId: 0,
                title: item['title'] ?? '',
                inventor: item['inventor'] ?? '',
                inventorAddress: item['inventor_address'] ?? '',
                applicant: item['applicant'] ?? '',
                applicantAddress: item['applicant_address'] ?? '',
                typeId: item['type_id'] ?? 0,
                userId: item['user_id'] ?? 0,
              ));
            }
          }
        } catch (e) {
          print('Error processing patent item: $e');
          print('Problematic data: $item');
          continue;
        }
      }

      if (patents.isEmpty) {
        throw DatabaseException('No valid patent locations found in response');
      }

      print('Successfully loaded ${patents.length} patent locations'); // Debug log
      return patents;
    } catch (e) {
      print('Patent data loading error: $e'); 
      rethrow;
    }
  }

// Trong file databases.dart
Future<List<TrademarkMapModel>> loadTrademarkLocations() async {
  try {
    final response = await http.get(Uri.parse(trademarkLocationsUrl));
    
    if (response.statusCode != 200) {
      throw DatabaseException('Lỗi khi tải dữ liệu: ${response.statusCode}');
    }

    final data = json.decode(response.body);
    if (!data['success']) {
      throw DatabaseException(data['message'] ?? 'Không thể lấy dữ liệu nhãn hiệu');
    }

    List<TrademarkMapModel> trademarks = [];
    for (final item in data['data']) {
      try {
        if (item != null && item['coordinates'] != null) {
          final coordinates = item['coordinates'];
          if (coordinates['latitude'] != null && coordinates['longitude'] != null) {
            // Xử lý ngày tháng an toàn hơn
            DateTime filingDate;
            try {
              filingDate = item['filing_date'] != null ? 
                DateTime.parse(item['filing_date']) : 
                DateTime.now();
            } catch (e) {
              // Nếu parse lỗi thì dùng ngày hiện tại
              filingDate = DateTime.now();
            }
            
            trademarks.add(TrademarkMapModel(
              id: item['id'] ?? 0,
              mark: item['mark'] ?? '',
              owner: item['owner'] ?? '',
              address: item['address'] ?? '',
              status: item['status'] ?? '',
              filingDate: filingDate,
              filingNumber: item['filing_number'] ?? '',
              registrationNumber: item['registration_number'] ?? '',
              imageUrl: item['image_url'] ?? '',
              latitude: double.parse(coordinates['latitude'].toString()),
              longitude: double.parse(coordinates['longitude'].toString()),
            ));
          }
        }
      } catch (e) {
        print('Error processing trademark data: $e');
        continue;
      }
    }

    return trademarks;
  } catch (e) {
    throw DatabaseException('Lỗi khi tải dữ liệu nhãn hiệu: $e');
  }
}
}