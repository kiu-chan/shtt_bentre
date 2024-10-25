import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:latlong2/latlong.dart';
import 'package:shtt_bentre/src/mainData/data/commune.dart';
import 'package:shtt_bentre/src/mainData/data/district.dart';
import 'package:shtt_bentre/src/mainData/data/border.dart';

class Database {
  static final Database _instance = Database._internal();

  factory Database() {
    return _instance;
  }

  Database._internal();

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

  PostgreSQLConnection? _connection;
  bool _isConnecting = false;
  
  static const int _maxRetries = 3;
  static const Duration _connectionTimeout = Duration(seconds: 30);
  static const Duration _queryTimeout = Duration(seconds: 20);

  Future<void> _ensureConnection() async {
    if (_connection != null && !_connection!.isClosed) return;
    
    if (_isConnecting) {
      int attempts = 0;
      while (_isConnecting && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }
      if (_connection != null && !_connection!.isClosed) return;
    }

    _isConnecting = true;
    try {
      _connection = PostgreSQLConnection(
        '163.44.193.74',
        5432,
        'shtt_bentre',
        username: 'postgres',
        password: 'yfti*m0xZYtRy3QfF)tV',
        timeoutInSeconds: _connectionTimeout.inSeconds,
        queryTimeoutInSeconds: _queryTimeout.inSeconds,
      );
      await _connection!.open();
    } catch (e) {
      print('Error establishing database connection: $e');
      _connection = null;
      throw DatabaseException('Không thể kết nối tới cơ sở dữ liệu');
    } finally {
      _isConnecting = false;
    }
  }

// Trong phương thức loadCommuneData(), thay đổi cách xử lý dữ liệu:

Future<List<Commune>> loadCommuneData() async {
  return _retryOperation(() async {
    await _ensureConnection();
    
    final results = await _connection!.query('''
      SELECT 
        id,
        name,
        district_id,
        ST_AsText(geom) as geom_text,
        TRIM(area) as area_str,
        TRIM(population) as population_str,
        COALESCE(updated_year, '') as updated_year
      FROM public.map_communes
      ORDER BY district_id, id
    ''');

    List<Commune> communes = [];
    
    for (int i = 0; i < results.length; i++) {
      try {
        final row = results[i];
        final id = row[0] as int;
        final name = row[1] as String;
        final districtId = row[2] as int;
        final geomText = row[3] as String;
        
        // Parse area safely
        double area = 0.0;
        try {
          final areaStr = (row[4] as String).replaceAll(' ', '');
          area = double.tryParse(areaStr) ?? 0.0;
        } catch (e) {
          print('Error parsing area for row $i: ${row[4]}');
        }

        // Parse population safely
        int population = 0;
        try {
          final popStr = (row[5] as String).replaceAll(' ', '');
          population = int.tryParse(popStr) ?? 0;
        } catch (e) {
          print('Error parsing population for row $i: ${row[5]}');
        }

        final updatedYear = row[6] as String;
        
        List<List<LatLng>> polygons = _parseMultiPolygon(geomText);
        if (polygons.isNotEmpty) {
          communes.add(Commune(
            id: id,
            name: name,
            districtId: districtId,
            polygons: polygons,
            color: communeColors[i % communeColors.length],
            area: area,
            population: population,
            updatedYear: updatedYear,
          ));
        }
      } catch (e) {
        print('Error processing commune row $i: $e');
        continue;
      }
    }

    if (communes.isEmpty) {
      throw DatabaseException('Không tìm thấy dữ liệu xã');
    }

    return communes;
  });
}

  Future<List<District>> loadDistrictData() async {
    return _retryOperation(() async {
      await _ensureConnection();

      final results = await _connection!.query('''
        SELECT 
          id,
          name,
          ST_AsText(geom) as geom_text
        FROM public.map_districts
        ORDER BY id
      ''');

      List<District> districts = [];
      
      for (int i = 0; i < results.length; i++) {
        try {
          final row = results[i];
          final id = row[0] as int;
          final name = row[1] as String;
          final geomText = row[2] as String;
          
          List<List<LatLng>> polygons = _parseMultiPolygon(geomText);
          if (polygons.isNotEmpty) {
            districts.add(District(
              id: id,
              name: name,
              polygons: polygons,
              color: districtColors[i % districtColors.length],
            ));
          }
        } catch (e) {
          print('Error processing district row $i: $e');
          continue;
        }
      }

      if (districts.isEmpty) {
        throw DatabaseException('Không tìm thấy dữ liệu huyện');
      }

      return districts;
    });
  }

  Future<List<MapBorder>> loadBorderData() async {
    return _retryOperation(() async {
      await _ensureConnection();

      final results = await _connection!.query('''
        SELECT 
          id,
          ST_AsText(geom) as geom_text
        FROM public.map_borders
        ORDER BY id
      ''');

      List<MapBorder> borders = [];
      
      for (final row in results) {
        try {
          final id = row[0] as int;
          final geomText = row[1] as String;
          
          List<LatLng> points = _parseMultiLineString(geomText);
          if (points.isNotEmpty) {
            borders.add(MapBorder(
              id: id,
              points: points,
            ));
          }
        } catch (e) {
          print('Error processing border row: $e');
          continue;
        }
      }

      if (borders.isEmpty) {
        throw DatabaseException('Không tìm thấy dữ liệu viền bản đồ');
      }

      return borders;
    });
  }

  Future<T> _retryOperation<T>(Future<T> Function() operation) async {
    int attempts = 0;
    while (attempts < _maxRetries) {
      try {
        return await operation();
      } on PostgreSQLException catch (e) {
        attempts++;
        print('Database operation failed (attempt $attempts): ${e.message}');
        if (attempts == _maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: 500 * attempts));
        await _resetConnection();
      }
    }
    throw DatabaseException('Thao tác không thành công sau $_maxRetries lần thử');
  }

  Future<void> _resetConnection() async {
    try {
      await _connection?.close();
    } catch (e) {
      print('Error closing connection: $e');
    } finally {
      _connection = null;
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

  Future<void> dispose() async {
    await _resetConnection();
  }
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
  
  @override
  String toString() => 'DatabaseException: $message';
}