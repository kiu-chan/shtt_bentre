// lib/src/pages/map/map_state_manager.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shtt_bentre/src/mainData/config/map.dart';
import 'package:shtt_bentre/src/mainData/data/map/industrial_design.dart';
import 'package:shtt_bentre/src/mainData/data/map/commune.dart';
import 'package:shtt_bentre/src/mainData/data/map/district.dart';
import 'package:shtt_bentre/src/mainData/data/map/map_type.dart';
import 'package:shtt_bentre/src/mainData/data/map/patent.dart';
import 'package:shtt_bentre/src/mainData/data/map/trademark.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapStateManager {
  final TickerProvider vsync;
  final VoidCallback onStateChanged;
  final List<District> districts;

  late final AnimationController _legendAnimationController;
  late final Animation<Offset> legendSlideAnimation;
  late final BuildContext _context;

  double currentZoom = MapConfig.currentZoom;
  bool isLegendVisible = MapConfig.isLegendVisible;
  bool isRightMenuOpen = MapConfig.isRightMenuOpen;
  bool isBorderEnabled = MapConfig.isBorderEnabled;
  bool isCommuneEnabled = MapConfig.isCommuneEnabled;
  bool isDistrictEnabled = MapConfig.isDistrictEnabled;
  bool isPatentEnabled = MapConfig.isPatentEnabled;
  bool isTrademarkEnabled = MapConfig.isTrademarkEnabled;
  bool isLegendAnimating = MapConfig.isLegendAnimating;
  bool isIndustrialDesignEnabled = MapConfig.isIndustrialDesignEnabled;

  String? selectedDistrictName;
  String? selectedCommuneName;
  Patent? selectedPatent;
  TrademarkMapModel? selectedTrademark;
  IndustrialDesignMapModel? selectedIndustrialDesign;
  MapType currentMapType = MapType.streets;

  MapStateManager({
    required this.vsync,
    required this.onStateChanged,
    required this.districts,
  }) {
    _setupAnimations();
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  void _setupAnimations() {
    _legendAnimationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 300),
    );

    legendSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _legendAnimationController,
      curve: Curves.easeInOut,
    ));

    _legendAnimationController.forward();
  }

  void toggleLegend() {
    if (isLegendAnimating) return;
    
    isLegendVisible = !isLegendVisible;
    isLegendAnimating = true;
    onStateChanged();
    
    if (isLegendVisible) {
      _legendAnimationController.forward().then((_) {
        isLegendAnimating = false;
        onStateChanged();
      });
    } else {
      _legendAnimationController.reverse().then((_) {
        isLegendAnimating = false;
        onStateChanged();
      });
    }
  }

  void changeMapType(MapType newType) {
    currentMapType = newType;
    onStateChanged();
  }

  void toggleRightMenu() {
    if (isLegendAnimating) return;
    isRightMenuOpen = !isRightMenuOpen;
    onStateChanged();
  }

  void toggleDistrict() {
    if (isLegendAnimating) return;
    isDistrictEnabled = !isDistrictEnabled;
    for (var district in districts) {
      district.isVisible = isDistrictEnabled;
    }
    onStateChanged();
  }

  void toggleDistrictVisibility(int index) {
    if (isLegendAnimating) return;
    if (index >= 0 && index < districts.length) {
      districts[index].isVisible = !districts[index].isVisible;
      onStateChanged();
    }
  }

  void setDistrictsVisible(bool visible) {
    for (var district in districts) {
      district.isVisible = visible;
    }
  }

  void toggleBorder() {
    if (!isLegendAnimating) {
      isBorderEnabled = !isBorderEnabled;
      onStateChanged();
    }
  }

  void toggleCommune() {
    if (!isLegendAnimating) {
      isCommuneEnabled = !isCommuneEnabled;
      onStateChanged();
    }
  }

  void togglePatent() {
    if (!isLegendAnimating) {
      isPatentEnabled = !isPatentEnabled;
      onStateChanged();
    }
  }

  void toggleTrademark() {
    if (!isLegendAnimating) {
      isTrademarkEnabled = !isTrademarkEnabled;
      onStateChanged();
    }
  }

  void zoom(MapController mapController, bool zoomIn) {
    currentZoom = (currentZoom + (zoomIn ? 0.5 : -0.5)).clamp(1.0, 18.0);
    mapController.move(mapController.center, currentZoom);
    onStateChanged();
  }

  void showDistrictInfo(String name) {
    if (isLegendAnimating) return;
    selectedDistrictName = name;
    selectedCommuneName = null;
    selectedPatent = null;
    selectedTrademark = null;
    onStateChanged();
    
    final l10n = AppLocalizations.of(_context)!;
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text('${l10n.districtLabel}: $name'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void showCommuneInfo(Commune commune) {
    if (isLegendAnimating) return;
    selectedCommuneName = commune.name;
    selectedDistrictName = null;
    selectedPatent = null;
    selectedTrademark = null;
    onStateChanged();
    
    final l10n = AppLocalizations.of(_context)!;
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text(
          '${l10n.communeLabel}: ${commune.name}\n'
          '${l10n.area}: ${commune.area.toStringAsFixed(2)} ${l10n.areaUnit}\n'
          '${l10n.population}: ${commune.population}\n'
          '${l10n.update}: ${commune.updatedYear}',
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void showPatentInfo(Patent patent) {
    if (isLegendAnimating) return;
    selectedPatent = patent;
    selectedDistrictName = null;
    selectedCommuneName = null;
    selectedTrademark = null;
    onStateChanged();
  }

  void showTrademarkInfo(TrademarkMapModel trademark) {
    if (isLegendAnimating) return;
    selectedTrademark = trademark;
    selectedDistrictName = null;
    selectedCommuneName = null;
    selectedPatent = null;
    onStateChanged();
  }

  void toggleIndustrialDesign() {
    if (!isLegendAnimating) {
      isIndustrialDesignEnabled = !isIndustrialDesignEnabled;
      onStateChanged();
    }
  }

  void showIndustrialDesignInfo(IndustrialDesignMapModel design) {
    if (isLegendAnimating) return;
    selectedIndustrialDesign = design;
    selectedDistrictName = null;
    selectedCommuneName = null;
    selectedPatent = null;
    selectedTrademark = null;
    onStateChanged();
  }

  void onMapTap(_, __) {
    if (isLegendAnimating) return;
    selectedDistrictName = null;
    selectedCommuneName = null;
    selectedPatent = null;
    selectedTrademark = null;
    selectedIndustrialDesign = null;
    onStateChanged();
  }

  void dispose() {
    _legendAnimationController.dispose();
  }
}