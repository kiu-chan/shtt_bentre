import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shtt_bentre/src/mainData/config/map.dart';
import 'package:shtt_bentre/src/mainData/data/industrial_design.dart';
import 'package:shtt_bentre/src/mainData/data/map/border.dart';
import 'package:shtt_bentre/src/mainData/data/map/commune.dart';
import 'package:shtt_bentre/src/mainData/data/map/district.dart';
import 'package:shtt_bentre/src/mainData/data/patent.dart';
import 'package:shtt_bentre/src/mainData/data/trademark.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';

class MapDataHandler {
  final Database _database = Database();
  Timer? _refreshTimer;
  DateTime? _lastRefreshTime;

  // Center coordinates
  final LatLng center = LatLng(
    MapConfig.defaultLatitude,
    MapConfig.defaultLongitude
  );

  // Data collections
  List<District> districts = [];
  List<Commune> communes = [];
  List<MapBorder> borders = [];
  List<Patent> patents = [];
  List<TrademarkMapModel> trademarks = [];
  List<IndustrialDesignMapModel> industrialDesigns = [];

  // Loading states
  bool isLoading = MapConfig.isLoading;
  bool isDataLoading = MapConfig.isDataLoading;
  bool isBorderLoading = MapConfig.isBorderLoading;
  bool isCommuneLoading = MapConfig.isCommuneLoading;
  bool isPatentLoading = MapConfig.isPatentLoading;
  bool isTrademarkLoading = MapConfig.isTrademarkLoading;
  bool isIndustrialDesignLoading = MapConfig.isIndustrialDesignLoading;

  // Cache management
  final Map<String, dynamic> _dataCache = {};
  
  MapDataHandler() {
    if (MapConfig.dataRefreshInterval > 0) {
      _startRefreshTimer();
    }
  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(
      Duration(minutes: MapConfig.dataRefreshInterval),
      (_) => _refreshDataIfNeeded()
    );
  }

  Future<void> _refreshDataIfNeeded() async {
    if (_lastRefreshTime == null || 
        DateTime.now().difference(_lastRefreshTime!) > 
        Duration(minutes: MapConfig.dataRefreshInterval)) {
      await loadInitialData();
    }
  }

  Future<void> loadInitialData() async {
    try {
      final futures = await Future.wait([
        _loadDataWithCache('districts', () => _database.loadDistrictData()),
        _loadDataWithCache('communes', () => _database.loadCommuneData()),
        _loadDataWithCache('borders', () => _database.loadBorderData()),
        _loadDataWithCache('patents', () => _database.loadPatentData()),
        _loadDataWithCache('trademarks', () => _database.loadTrademarkLocations()),
        _loadDataWithCache('industrialDesigns', () => _database.loadIndustrialDesignLocations()),
      ]);

      // Assign results
      districts = futures[0] as List<District>;
      communes = futures[1] as List<Commune>;
      borders = futures[2] as List<MapBorder>;
      patents = futures[3] as List<Patent>;
      trademarks = futures[4] as List<TrademarkMapModel>;
      industrialDesigns = futures[5] as List<IndustrialDesignMapModel>;

      _lastRefreshTime = DateTime.now();
      
    } catch (e) {
      print('Error loading initial data: $e');
    } finally {
      // Reset loading states
      _setLoadingStates(false);
    }
  }

  Future<T> _loadDataWithCache<T>(String key, Future<T> Function() loader) async {
    if (MapConfig.enableDataCaching && _dataCache.containsKey(key)) {
      final cached = _dataCache[key];
      final cacheTime = _dataCache['${key}_time'] as DateTime?;
      
      if (cacheTime != null && 
          DateTime.now().difference(cacheTime).inMinutes < MapConfig.maxCacheAge) {
        return cached as T;
      }
    }

    final data = await loader();
    if (MapConfig.enableDataCaching) {
      _dataCache[key] = data;
      _dataCache['${key}_time'] = DateTime.now();
    }
    return data;
  }

  void _setLoadingStates(bool loading) {
    isLoading = loading;
    isDataLoading = loading;
    isBorderLoading = loading;
    isCommuneLoading = loading;
    isPatentLoading = loading;
    isTrademarkLoading = loading;
    isIndustrialDesignLoading = loading;
  }

  Future<void> loadBorderData(Function(void Function())? setState) async {
    if (isDataLoading || borders.isNotEmpty) {
      if (setState != null) setState(() {});
      return;
    }

    isDataLoading = true;
    isBorderLoading = true;
    if (setState != null) setState(() {});

    try {
      borders = await _loadDataWithCache('borders', () => _database.loadBorderData());
    } catch (e) {
      print('Error loading border data: $e');
    } finally {
      isBorderLoading = false;
      isDataLoading = false;
      if (setState != null) setState(() {});
    }
  }

  Future<void> loadCommuneData(Function(void Function())? setState) async {
    if (isDataLoading || communes.isNotEmpty) {
      if (setState != null) setState(() {});
      return;
    }

    isDataLoading = true;
    isCommuneLoading = true;
    if (setState != null) setState(() {});

    try {
      communes = await _loadDataWithCache('communes', () => _database.loadCommuneData());
    } catch (e) {
      print('Error loading commune data: $e');
    } finally {
      isCommuneLoading = false;
      isDataLoading = false;
      if (setState != null) setState(() {});
    }
  }

  Future<void> loadPatentData(Function(void Function())? setState) async {
    if (isDataLoading || patents.isNotEmpty) {
      if (setState != null) setState(() {});
      return;
    }

    isDataLoading = true;
    isPatentLoading = true;
    if (setState != null) setState(() {});

    try {
      patents = await _loadDataWithCache('patents', () => _database.loadPatentData());
    } catch (e) {
      print('Error loading patent data: $e');
    } finally {
      isPatentLoading = false;
      isDataLoading = false;
      if (setState != null) setState(() {});
    }
  }

  Future<void> loadTrademarkData(Function(void Function())? setState) async {
    if (isDataLoading || trademarks.isNotEmpty) {
      if (setState != null) setState(() {});
      return;
    }

    isDataLoading = true;
    isTrademarkLoading = true;
    if (setState != null) setState(() {});

    try {
      trademarks = await _loadDataWithCache(
        'trademarks', 
        () => _database.loadTrademarkLocations()
      );
    } catch (e) {
      print('Error loading trademark data: $e');
    } finally {
      isTrademarkLoading = false;
      isDataLoading = false;
      if (setState != null) setState(() {});
    }
  }

  Future<void> loadIndustrialDesignData(Function(void Function())? setState) async {
    if (isDataLoading || industrialDesigns.isNotEmpty) {
      if (setState != null) setState(() {});
      return;
    }

    isDataLoading = true;
    isIndustrialDesignLoading = true;
    if (setState != null) setState(() {});

    try {
      industrialDesigns = await _loadDataWithCache(
        'industrialDesigns',
        () => _database.loadIndustrialDesignLocations()
      );
    } catch (e) {
      print('Error loading industrial design data: $e');
    } finally {
      isIndustrialDesignLoading = false;
      isDataLoading = false;
      if (setState != null) setState(() {});
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

  void clearCache() {
    _dataCache.clear();
  }

  void dispose() {
    _refreshTimer?.cancel();
    _database.dispose();
    clearCache();
  }
}