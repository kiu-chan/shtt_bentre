import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shtt_bentre/src/pages/map/map_data_handler.dart';
import 'package:shtt_bentre/src/pages/map/map_state_manager.dart';
import 'map_page_view.dart';
import 'map_page.dart';

class MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  late final MapController _mapController;
  late final MapDataHandler _dataHandler;
  late final MapStateManager _stateManager;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _dataHandler = MapDataHandler();
    _stateManager = MapStateManager(
      vsync: this,
      onStateChanged: () => setState(() {}),
      districts: _dataHandler.districts,
    );

    _loadInitialData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stateManager.setContext(context);
  }

  Future<void> _loadInitialData() async {
    await _dataHandler.loadInitialData();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    _dataHandler.dispose();
    _stateManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MapPageView(
      mapController: _mapController,
      currentZoom: _stateManager.currentZoom,
      center: _dataHandler.center,
      districts: _dataHandler.districts,
      communes: _dataHandler.communes,
      patents: _dataHandler.patents,
      trademarks: _dataHandler.trademarks,
      industrialDesigns: _dataHandler.industrialDesigns,
      isLoading: _dataHandler.isLoading,
      isLegendVisible: _stateManager.isLegendVisible,
      isRightMenuOpen: _stateManager.isRightMenuOpen,
      isBorderEnabled: _stateManager.isBorderEnabled,
      isCommuneEnabled: _stateManager.isCommuneEnabled,
      isDistrictEnabled: _stateManager.isDistrictEnabled,
      isPatentEnabled: _stateManager.isPatentEnabled,
      isTrademarkEnabled: _stateManager.isTrademarkEnabled,
      isIndustrialDesignEnabled: _stateManager.isIndustrialDesignEnabled,
      isBorderLoading: _dataHandler.isBorderLoading,
      isCommuneLoading: _dataHandler.isCommuneLoading,
      isPatentLoading: _dataHandler.isPatentLoading,
      isTrademarkLoading: _dataHandler.isTrademarkLoading,
      isIndustrialDesignLoading: _dataHandler.isIndustrialDesignLoading,
      selectedDistrictName: _stateManager.selectedDistrictName,
      selectedCommuneName: _stateManager.selectedCommuneName,
      selectedPatent: _stateManager.selectedPatent,
      selectedTrademark: _stateManager.selectedTrademark,
      selectedIndustrialDesign: _stateManager.selectedIndustrialDesign,
      legendSlideAnimation: _stateManager.legendSlideAnimation,
      onToggleLegend: _stateManager.toggleLegend,
      onToggleRightMenu: _stateManager.toggleRightMenu,
      onToggleBorder: () {
        _stateManager.toggleBorder();
        _dataHandler.loadBorderData(setState);
      },
      onToggleCommune: () {
        _stateManager.toggleCommune();
        _dataHandler.loadCommuneData(setState);
      },
      onToggleDistrict: _stateManager.toggleDistrict,
      onTogglePatent: () {
        _stateManager.togglePatent();
        _dataHandler.loadPatentData(setState);
      },
      onToggleTrademark: () {
        _stateManager.toggleTrademark();
        _dataHandler.loadTrademarkData(setState);
      },
      onToggleIndustrialDesign: () {
        _stateManager.toggleIndustrialDesign();
        _dataHandler.loadIndustrialDesignData(setState);
      },
      onToggleDistrictVisibility: _stateManager.toggleDistrictVisibility,
      onZoomIn: () => _stateManager.zoom(_mapController, true),
      onZoomOut: () => _stateManager.zoom(_mapController, false),
      onShowDistrictInfo: _stateManager.showDistrictInfo,
      onShowCommuneInfo: _stateManager.showCommuneInfo,
      onShowPatentInfo: _stateManager.showPatentInfo,
      onShowTrademarkInfo: _stateManager.showTrademarkInfo,
      onShowIndustrialDesignInfo: _stateManager.showIndustrialDesignInfo,
      onMapTap: _stateManager.onMapTap,
      onZoomChanged: (zoom) {
        _stateManager.currentZoom = zoom;
        setState(() {});
      },
      polygons: _dataHandler.buildPolygons(
        _stateManager.isDistrictEnabled,
        _stateManager.isCommuneEnabled,
        _stateManager.selectedDistrictName,
        _stateManager.selectedCommuneName,
      ),
      borderLines: _dataHandler.buildBorderLines(_stateManager.isBorderEnabled),
    );
  }
}