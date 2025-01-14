  
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/config/colors.dart';
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/map/border.dart';
import 'package:shtt_bentre/src/mainData/data/map/commune.dart';
import 'package:shtt_bentre/src/mainData/data/map/district.dart';
import 'dart:convert';

import 'package:shtt_bentre/src/mainData/database/database_exception.dart';

class MapData {
  static String communesUrl = MainUrl.communesUrl;
  static String districtsUrl = MainUrl.districtsUrl;
  static String bordersUrl = MainUrl.bordersUrl;

  List<Color> communeColors = MainColors().communeColors;

  final List<Color> districtColors = MainColors().districtColors;

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

  Future<List<Commune>> loadCommuneData() async {
    try {
      final response = await http.get(Uri.parse(communesUrl));
      
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
      final response = await http.get(Uri.parse(districtsUrl));
      
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
          // Safe number conversions
          double area = 0.0;
          if (item['area'] is num) {
            area = (item['area'] as num).toDouble();
          } else if (item['area'] is String) {
            area = double.tryParse(item['area'].toString()) ?? 0.0;
          }

          int population = 0;
          if (item['population'] is num) {
            population = (item['population'] as num).toInt();
          } else if (item['population'] is String) {
            population = int.tryParse(item['population'].toString()) ?? 0;
          }

          int updatedYear = 0;
          if (item['updated_year'] is num) {
            updatedYear = (item['updated_year'] as num).toInt();
          } else if (item['updated_year'] is String) {
            updatedYear = int.tryParse(item['updated_year'].toString()) ?? 0;
          }

          List<List<LatLng>> polygons = _parseMultiPolygon(item['geom_text']);
          if (polygons.isNotEmpty) {
            districts.add(District(
              id: item['id'],
              name: item['name'],
              area: area,
              population: population,
              updated_year: updatedYear,
              polygons: polygons,
              color: districtColors[i % districtColors.length],
            ));
          }
        } catch (e) {
          print('Error processing district data at index $i: $e');
          print('Data causing error: ${item.toString()}');
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
      final response = await http.get(Uri.parse(bordersUrl));
      
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
}