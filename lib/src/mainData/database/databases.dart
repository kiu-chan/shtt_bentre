import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/data/home/trademark.dart';
import 'dart:convert';
import 'package:shtt_bentre/src/mainData/data/map/commune.dart';
import 'package:shtt_bentre/src/mainData/data/map/district.dart';
import 'package:shtt_bentre/src/mainData/data/map/border.dart';
import 'package:shtt_bentre/src/mainData/data/patent.dart';
import 'package:shtt_bentre/src/mainData/data/trademark.dart';

class Database {
  static final Database _instance = Database._internal();

  factory Database() {
    return _instance;
  }

  Database._internal();

  // Base URL for API
  static const String baseUrl = 'https://shttbentre.girc.edu.vn/api';

  final List<Color> districtColors = [
    Colors.red.withOpacity(0.3),
    Colors.blue.withOpacity(0.3),
    Colors.green.withOpacity(0.3),
    Colors.orange.withOpacity(0.3),
    Colors.purple.withOpacity(0.3),
    Colors.teal.withOpacity(0.3),
    Colors.pink.withOpacity(0.3),
    Colors.indigo.withOpacity(0.3),
    Colors.amber.withOpacity(0.3),
    Colors.cyan.withOpacity(0.3),
  ];

  final List<Color> communeColors = [
    Colors.lightBlue.withOpacity(0.3),
    Colors.lightGreen.withOpacity(0.3),
    Colors.amber.withOpacity(0.3),
    Colors.purple.withOpacity(0.3),
    Colors.teal.withOpacity(0.3),
    Colors.orange.withOpacity(0.3),
    Colors.pink.withOpacity(0.3),
    Colors.indigo.withOpacity(0.3),
  ];

  Future<List<Commune>> loadCommuneData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/map/communes'));
      
      if (response.statusCode != 200) {
        throw DatabaseException('Lỗi khi tải dữ liệu: ${response.statusCode}');
      }

      final data = json.decode(response.body);
      if (!data['success']) {
        throw DatabaseException(data['message'] ?? 'Không thể lấy dữ liệu xã');
      }

      List<Commune> communes = [];
      for (var i = 0; i < data['data'].length; i++) {
        final item = data['data'][i];
        try {
          List<List<LatLng>> polygons = _parseMultiPolygon(item['geom_text']);
          if (polygons.isNotEmpty) {
            communes.add(Commune(
              id: item['id'],
              name: item['name'],
              districtId: item['district_id'],
              polygons: polygons,
              color: communeColors[i % communeColors.length],
              area: double.tryParse(item['area'].toString()) ?? 0.0,
              population: int.tryParse(item['population'].toString()) ?? 0,
              updatedYear: item['updated_year'],
            ));
          }
        } catch (e) {
          print('Error processing commune data at index $i: $e');
          continue;
        }
      }

      if (communes.isEmpty) {
        throw DatabaseException('Không tìm thấy dữ liệu xã hợp lệ');
      }

      return communes;
    } catch (e) {
      throw DatabaseException('Lỗi khi tải dữ liệu xã: $e');
    }
  }

  Future<List<District>> loadDistrictData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/map/districts'));
      
      if (response.statusCode != 200) {
        throw DatabaseException('Lỗi khi tải dữ liệu: ${response.statusCode}');
      }

      final data = json.decode(response.body);
      if (!data['success']) {
        throw DatabaseException(data['message'] ?? 'Không thể lấy dữ liệu huyện');
      }

      List<District> districts = [];
      for (var i = 0; i < data['data'].length; i++) {
        final item = data['data'][i];
        try {
          List<List<LatLng>> polygons = _parseMultiPolygon(item['geom_text']);
          if (polygons.isNotEmpty) {
            districts.add(District(
              id: item['id'],
              name: item['name'],
              polygons: polygons,
              color: districtColors[i % districtColors.length],
            ));
          }
        } catch (e) {
          print('Error processing district data at index $i: $e');
          continue;
        }
      }

      if (districts.isEmpty) {
        throw DatabaseException('Không tìm thấy dữ liệu huyện hợp lệ');
      }

      return districts;
    } catch (e) {
      throw DatabaseException('Lỗi khi tải dữ liệu huyện: $e');
    }
  }

  Future<List<MapBorder>> loadBorderData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/map/borders'));
      
      if (response.statusCode != 200) {
        throw DatabaseException('Lỗi khi tải dữ liệu: ${response.statusCode}');
      }

      final data = json.decode(response.body);
      if (!data['success']) {
        throw DatabaseException(data['message'] ?? 'Không thể lấy dữ liệu viền bản đồ');
      }

      List<MapBorder> borders = [];
      for (final item in data['data']) {
        try {
          List<LatLng> points = _parseMultiLineString(item['geom_text']);
          if (points.isNotEmpty) {
            borders.add(MapBorder(
              id: item['id'],
              points: points,
            ));
          }
        } catch (e) {
          print('Error processing border data: $e');
          continue;
        }
      }

      if (borders.isEmpty) {
        throw DatabaseException('Không tìm thấy dữ liệu viền bản đồ hợp lệ');
      }

      return borders;
    } catch (e) {
      throw DatabaseException('Lỗi khi tải dữ liệu viền bản đồ: $e');
    }
  }

  List<LatLng> _parseMultiLineString(String geomText) {
    try {
      String cleanedText = geomText.trim();
      if (cleanedText.startsWith('SRID=')) {
        cleanedText = cleanedText.substring(cleanedText.indexOf(';') + 1).trim();
      }

      cleanedText = cleanedText
          .replaceFirst('MULTILINESTRING((', '')
          .replaceFirst('))', '')
          .trim();

      List<String> pairs = cleanedText.split(',');
      return pairs.map((pair) {
        try {
          final coords = pair.trim().split(RegExp(r'\s+'));
          if (coords.length >= 2) {
            return LatLng(
              double.parse(coords[1]),
              double.parse(coords[0])
            );
          }
        } catch (e) {
          print('Error parsing coordinate pair: $pair, error: $e');
        }
        return null;
      })
      .where((point) => point != null)
      .cast<LatLng>()
      .toList();
    } catch (e) {
      print('Error parsing multilinestring: $e');
      return [];
    }
  }

  List<List<LatLng>> _parseMultiPolygon(String geomText) {
    try {
      String cleanedText = geomText.trim();
      if (cleanedText.startsWith('SRID=')) {
        cleanedText = cleanedText.substring(cleanedText.indexOf(';') + 1).trim();
      }

      cleanedText = cleanedText
          .replaceFirst('MULTIPOLYGON(', '')
          .replaceFirst(RegExp(r'\)$'), '')
          .trim();

      List<String> polygonStrings = [];
      int depth = 0;
      StringBuffer currentPolygon = StringBuffer();

      for (int i = 0; i < cleanedText.length; i++) {
        String char = cleanedText[i];
        if (char == '(') depth++;
        if (char == ')') depth--;

        currentPolygon.write(char);

        if (depth == 0 && char == ')') {
          polygonStrings.add(currentPolygon.toString());
          currentPolygon = StringBuffer();
          while (i + 1 < cleanedText.length && 
                 (cleanedText[i + 1] == ',' || cleanedText[i + 1] == ' ')) {
            i++;
          }
        }
      }

      return polygonStrings.map((polygonString) {
        try {
          String coords = polygonString
              .replaceFirst('((', '')
              .replaceFirst('))', '')
              .trim();

          List<String> pairs = coords.split(',');
          return pairs.map((pair) {
            try {
              final coords = pair.trim().split(RegExp(r'\s+'));
              if (coords.length >= 2) {
                return LatLng(
                  double.parse(coords[1]),
                  double.parse(coords[0])
                );
              }
            } catch (e) {
              print('Error parsing coordinate pair: $pair, error: $e');
            }
            return null;
          })
          .where((point) => point != null)
          .cast<LatLng>()
          .toList();
        } catch (e) {
          print('Error parsing polygon: $e');
          return <LatLng>[];
        }
      }).where((points) => points.isNotEmpty).toList();
    } catch (e) {
      print('Error parsing multipolygon: $e');
      return [];
    }
  }

  Future<List<Patent>> loadPatentData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/patent-locations'));
      
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
    final response = await http.get(Uri.parse('$baseUrl/trademark-locations'));
    
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

  void dispose() {
    // Cleanup if needed
  }
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
  
  @override
  String toString() => 'DatabaseException: $message';
}