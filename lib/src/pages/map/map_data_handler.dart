import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shtt_bentre/src/mainData/data/map/border.dart';
import 'package:shtt_bentre/src/mainData/data/map/commune.dart';
import 'package:shtt_bentre/src/mainData/data/map/district.dart';
import 'package:shtt_bentre/src/mainData/data/patent.dart';
import 'package:shtt_bentre/src/mainData/data/trademark.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';

class MapDataHandler {
  final Database _database = Database();
  final LatLng center = LatLng(10.2433, 106.3752);

  List<District> districts = [];
  List<Commune> communes = [];
  List<MapBorder> borders = [];
  List<Patent> patents = [];
  List<TrademarkMapModel> trademarks = [];

  bool isLoading = true;
  bool isBorderLoading = false;
  bool isCommuneLoading = false;
  bool isPatentLoading = false;
  bool isTrademarkLoading = false;
  bool isDataLoading = false;

  Future<void> loadInitialData() async {
    try {
      final loadedDistricts = await _database.loadDistrictData();
      districts = loadedDistricts;
      isLoading = false;
      await loadPatentData(null);
    } catch (e) {
      print('Error loading district data: $e');
      isLoading = false;
    }
  }

  Future<void> loadCommuneData(Function(void Function())? setState) async {
    if (isDataLoading || communes.isNotEmpty) {
      if (setState != null) {
        setState(() {});
      }
      return;
    }

    isDataLoading = true;
    isCommuneLoading = true;
    if (setState != null) {
      setState(() {});
    }

    try {
      final loadedCommunes = await _database.loadCommuneData();
      communes = loadedCommunes;
      isCommuneLoading = false;
      isDataLoading = false;
      if (setState != null) {
        setState(() {});
      }
    } catch (e) {
      print('Error loading commune data: $e');
      isCommuneLoading = false;
      isDataLoading = false;
      if (setState != null) {
        setState(() {});
      }
    }
  }

  Future<void> loadBorderData(Function(void Function())? setState) async {
    if (isDataLoading || borders.isNotEmpty) {
      if (setState != null) {
        setState(() {});
      }
      return;
    }

    isDataLoading = true;
    isBorderLoading = true;
    if (setState != null) {
      setState(() {});
    }

    try {
      final loadedBorders = await _database.loadBorderData();
      borders = loadedBorders;
      isBorderLoading = false;
      isDataLoading = false;
      if (setState != null) {
        setState(() {});
      }
    } catch (e) {
      print('Error loading border data: $e');
      isBorderLoading = false;
      isDataLoading = false;
      if (setState != null) {
        setState(() {});
      }
    }
  }

  Future<void> loadPatentData(Function(void Function())? setState) async {
    if (isDataLoading || patents.isNotEmpty) {
      if (setState != null) {
        setState(() {});
      }
      return;
    }

    isDataLoading = true;
    isPatentLoading = true;
    if (setState != null) {
      setState(() {});
    }

    try {
      final loadedPatents = await _database.loadPatentData();
      patents = loadedPatents;
      isPatentLoading = false;
      isDataLoading = false;
      if (setState != null) {
        setState(() {});
      }
    } catch (e) {
      print('Error loading patent data: $e');
      isPatentLoading = false;
      isDataLoading = false;
      if (setState != null) {
        setState(() {});
      }
    }
  }

  Future<void> loadTrademarkData(Function(void Function())? setState) async {
    if (isDataLoading || trademarks.isNotEmpty) {
      if (setState != null) {
        setState(() {});
      }
      return;
    }

    isDataLoading = true;
    isTrademarkLoading = true;
    if (setState != null) {
      setState(() {});
    }

    try {
      final response = await _database.loadTrademarkLocations();
      trademarks = response;
      isTrademarkLoading = false;
      isDataLoading = false;
      if (setState != null) {
        setState(() {});
      }
    } catch (e) {
      print('Error loading trademark data: $e');
      isTrademarkLoading = false;
      isDataLoading = false;
      if (setState != null) {
        setState(() {});
      }
    }
  }

  List<Polygon> buildPolygons(
    bool isDistrictEnabled,
    bool isCommuneEnabled,
    String? selectedDistrictName,
    String? selectedCommuneName,
  ) {
    List<Polygon> polygons = [];
    
    if (isDistrictEnabled) {
      for (var district in districts) {
        if (!district.isVisible) continue;
        
        for (var points in district.polygons) {
          polygons.add(Polygon(
            points: points,
            color: selectedDistrictName == district.name
                ? district.color.withOpacity(0.6)
                : district.color,
            borderStrokeWidth: 2.0,
            borderColor: district.color.withOpacity(1),
            isFilled: true,
          ));
        }
      }
    }

    if (isCommuneEnabled) {
      for (var commune in communes) {
        for (var points in commune.polygons) {
          polygons.add(Polygon(
            points: points,
            color: selectedCommuneName == commune.name
                ? commune.color.withOpacity(0.6)
                : commune.color,
            borderStrokeWidth: 1.5,
            borderColor: commune.color.withOpacity(1),
            isFilled: true,
          ));
        }
      }
    }

    return polygons;
  }

  List<Polyline> buildBorderLines(bool isBorderEnabled) {
    if (!isBorderEnabled || borders.isEmpty) return [];

    return borders.where((border) => border.points.isNotEmpty).map((border) {
      return Polyline(
        points: border.points,
        strokeWidth: 2.0,
        color: Colors.black,
      );
    }).toList();
  }

  void dispose() {
    _database.dispose();
  }
}