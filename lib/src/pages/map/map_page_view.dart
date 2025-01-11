import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shtt_bentre/src/mainData/config/file_path.dart';
import 'package:shtt_bentre/src/mainData/config/map.dart';
import 'package:shtt_bentre/src/mainData/data/map/industrial_design.dart';
import 'package:shtt_bentre/src/mainData/data/map/commune.dart';
import 'package:shtt_bentre/src/mainData/data/map/district.dart';
import 'package:shtt_bentre/src/mainData/data/map/patent.dart';
import 'package:shtt_bentre/src/mainData/data/map/trademark.dart';
import 'package:shtt_bentre/src/pages/map/info_cart/commune_info_card.dart';
import 'package:shtt_bentre/src/pages/map/info_cart/industrial_design_infor_card.dart';
import 'package:shtt_bentre/src/pages/map/legend.dart';
import 'package:shtt_bentre/src/pages/map/loading_indicator.dart';
import 'package:shtt_bentre/src/pages/map/map_controls.dart';
import 'package:shtt_bentre/src/pages/map/info_cart/patent_info_card.dart';
import 'package:shtt_bentre/src/pages/map/info_cart/trademark_info_card.dart';
import 'package:shtt_bentre/src/pages/map/right_menu.dart';
import 'package:shtt_bentre/src/pages/map/map_utils.dart';
import 'package:shtt_bentre/src/pages/map/search/map_search.dart';

class MapPageView extends StatelessWidget {
  final MapController mapController;
  final double currentZoom;
  final LatLng center;
  final List<District> districts;
  final List<Commune> communes;
  final List<Patent> patents;
  final List<TrademarkMapModel> trademarks;
  final List<IndustrialDesignMapModel> industrialDesigns;
  
  final bool isLoading;
  final bool isLegendVisible;
  final bool isRightMenuOpen;
  final bool isBorderEnabled;
  final bool isCommuneEnabled;
  final bool isDistrictEnabled;
  final bool isPatentEnabled;
  final bool isTrademarkEnabled;
  final bool isIndustrialDesignEnabled;
  final bool isBorderLoading;
  final bool isCommuneLoading;
  final bool isPatentLoading;
  final bool isTrademarkLoading;
  final bool isIndustrialDesignLoading;
  
  final String? selectedDistrictName;
  final String? selectedCommuneName;
  final Patent? selectedPatent;
  final TrademarkMapModel? selectedTrademark;
  final IndustrialDesignMapModel? selectedIndustrialDesign;
  
  final Animation<Offset> legendSlideAnimation;
  
  final VoidCallback? onToggleLegend;
  final VoidCallback onToggleRightMenu;
  final VoidCallback? onToggleBorder;
  final VoidCallback? onToggleCommune;
  final VoidCallback? onToggleDistrict;
  final VoidCallback? onTogglePatent;
  final VoidCallback? onToggleTrademark;
  final VoidCallback? onToggleIndustrialDesign;
  final Function(int) onToggleDistrictVisibility;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final Function(String) onShowDistrictInfo;
  final Function(Commune) onShowCommuneInfo;
  final Function(Patent) onShowPatentInfo;
  final Function(TrademarkMapModel) onShowTrademarkInfo;
  final Function(IndustrialDesignMapModel) onShowIndustrialDesignInfo;
  final Function(dynamic, dynamic) onMapTap;
  final Function(double) onZoomChanged;
  
  final List<Polygon> polygons;
  final List<Polyline> borderLines;

  const MapPageView({
    super.key,
    required this.mapController,
    required this.currentZoom,
    required this.center,
    required this.districts,
    required this.communes,
    required this.patents,
    required this.trademarks,
    required this.industrialDesigns,
    required this.isLoading,
    required this.isLegendVisible,
    required this.isRightMenuOpen,
    required this.isBorderEnabled,
    required this.isCommuneEnabled,
    required this.isDistrictEnabled,
    required this.isPatentEnabled,
    required this.isTrademarkEnabled,
    required this.isIndustrialDesignEnabled,
    required this.isBorderLoading,
    required this.isCommuneLoading,
    required this.isPatentLoading,
    required this.isTrademarkLoading,
    required this.isIndustrialDesignLoading,
    required this.selectedDistrictName,
    required this.selectedCommuneName,
    required this.selectedPatent,
    required this.selectedTrademark,
    required this.selectedIndustrialDesign,
    required this.legendSlideAnimation,
    required this.onToggleLegend,
    required this.onToggleRightMenu,
    required this.onToggleBorder,
    required this.onToggleCommune,
    required this.onToggleDistrict,
    required this.onTogglePatent,
    required this.onToggleTrademark,
    required this.onToggleIndustrialDesign,
    required this.onToggleDistrictVisibility,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onShowDistrictInfo,
    required this.onShowCommuneInfo,
    required this.onShowPatentInfo,
    required this.onShowTrademarkInfo,
    required this.onShowIndustrialDesignInfo,
    required this.onMapTap,
    required this.onZoomChanged,
    required this.polygons,
    required this.borderLines,
  });

  void _onLocationSelected(double latitude, double longitude, String name) {
    mapController.move(LatLng(latitude, longitude), MapConfig.mapSearch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          MapSearchBar(
            onLocationSelected: _onLocationSelected,
            isRightMenuOpen: isRightMenuOpen,
            onToggleLegend: onToggleLegend!,
            onToggleRightMenu: onToggleRightMenu,
            isLegendVisible: isLegendVisible,
          ),
          _buildLegend(context),
          _buildRightMenuContainer(),
          _buildInfoCards(),
          MapZoomControls(
            isRightMenuOpen: isRightMenuOpen,
            onZoomIn: onZoomIn,
            onZoomOut: onZoomOut,
          ),
          LoadingIndicator(
            isBorderLoading: isBorderLoading,
            isCommuneLoading: isCommuneLoading,
            isPatentLoading: isPatentLoading,
            isTrademarkLoading: isTrademarkLoading,
            isIndustrialDesignLoading: isIndustrialDesignLoading,
          ),
        ],
      ),
    );
  }


  Widget _buildMap() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: center,
        zoom: currentZoom,
        onTap: onMapTap,
        onPositionChanged: (position, hasGesture) {
          if (hasGesture && position.zoom != null) {
            onZoomChanged(position.zoom!);
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: MapConfig.mapUrl,
          userAgentPackageName: MapConfig.mapPackage,
        ),
        PolygonLayer(polygons: polygons),
        if (borderLines.isNotEmpty) PolylineLayer(polylines: borderLines),
        if (isPatentEnabled) _buildClusteredMarkers<Patent>(
          patents,
          isPatentEnabled,
          FilePath.patentPath,
          onShowPatentInfo,
          selectedPatent,
        ),
        if (isTrademarkEnabled) _buildClusteredMarkers<TrademarkMapModel>(
          trademarks,
          isTrademarkEnabled,
          FilePath.trademarkPath,
          onShowTrademarkInfo,
          selectedTrademark,
        ),
        if (isIndustrialDesignEnabled) _buildClusteredMarkers<IndustrialDesignMapModel>(
          industrialDesigns,
          isIndustrialDesignEnabled,
          FilePath.industrialDesignPath,
          onShowIndustrialDesignInfo,
          selectedIndustrialDesign,
        ),
      ],
    );
  }

  Widget _buildClusteredMarkers<T>(
    List<T> items,
    bool isEnabled,
    String assetPath,
    Function(T) onShowInfo,
    T? selectedItem) {
    if (!isEnabled || items.isEmpty) return const SizedBox.shrink();

    final allPoints = items.map((item) => (item as dynamic).location as LatLng).toList();
    final visiblePoints = MapUtils.clusterPoints(allPoints, currentZoom);

    return MarkerLayer(
      markers: visiblePoints.map((point) {
        final item = items.firstWhere(
          (item) => (item as dynamic).location.latitude == point.latitude 
                  && (item as dynamic).location.longitude == point.longitude
        );

        return Marker(
          width: 30.0,
          height: 30.0,
          point: point,
          builder: (ctx) => GestureDetector(
            onTap: () => onShowInfo(item),
            child: Image.asset(
              assetPath,
              width: (selectedItem as dynamic)?.id == (item as dynamic).id ? 30 : 24,
              height: (selectedItem as dynamic)?.id == (item as dynamic).id ? 30 : 24,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLegend(BuildContext context) {
    if (!isLegendVisible) return const SizedBox.shrink();
    
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          top: MediaQuery.of(context).padding.top + 80
        ),
        child: SlideTransition(
          position: legendSlideAnimation,
          child: MapLegend(
            districts: districts,
            communes: communes,
            patents: patents,
            trademarks: trademarks,
            industrialDesigns: industrialDesigns,
            isDistrictEnabled: isDistrictEnabled,
            isCommuneEnabled: isCommuneEnabled,
            isPatentEnabled: isPatentEnabled,
            isTrademarkEnabled: isTrademarkEnabled,
            isIndustrialDesignEnabled: isIndustrialDesignEnabled,
            selectedDistrictName: selectedDistrictName,
            selectedCommuneName: selectedCommuneName,
            onToggleDistrictVisibility: onToggleDistrictVisibility,
            onShowDistrictInfo: onShowDistrictInfo,
            onShowCommuneInfo: onShowCommuneInfo,
          ),
        ),
      ),
    );
  }

  Widget _buildRightMenuContainer() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.centerRight,
      transform: Matrix4.translationValues(
        isRightMenuOpen ? 0 : 300,
        0,
        0,
      ),
      child: SizedBox(
        width: 300,
        height: double.infinity,
        child: MapRightMenu(
          districts: districts,
          isDistrictEnabled: isDistrictEnabled,
          isBorderEnabled: isBorderEnabled,
          isCommuneEnabled: isCommuneEnabled,
          isPatentEnabled: isPatentEnabled,
          isTrademarkEnabled: isTrademarkEnabled,
          isIndustrialDesignEnabled: isIndustrialDesignEnabled,
          isBorderLoading: isBorderLoading,
          isCommuneLoading: isCommuneLoading,
          isPatentLoading: isPatentLoading,
          isTrademarkLoading: isTrademarkLoading,
          isIndustrialDesignLoading: isIndustrialDesignLoading,
          onToggleRightMenu: onToggleRightMenu,
          onToggleBorder: onToggleBorder,
          onToggleCommune: onToggleCommune,
          onToggleDistrict: onToggleDistrict,
          onTogglePatent: onTogglePatent,
          onToggleTrademark: onToggleTrademark,
          onToggleIndustrialDesign: onToggleIndustrialDesign,
          onToggleDistrictVisibility: onToggleDistrictVisibility,
        ),
      ),
    );
  }

  Widget _buildInfoCards() {
    return Stack(
      children: [
        if (selectedCommuneName != null)
          CommuneInfoCard(
            selectedCommuneName: selectedCommuneName!,
            communes: communes,
            onMapTap: onMapTap,
            isRightMenuOpen: isRightMenuOpen,
          ),
        if (selectedPatent != null)
          PatentInfoCard(
            selectedPatent: selectedPatent!,
            onMapTap: onMapTap,
            isRightMenuOpen: isRightMenuOpen,
          ),
        if (selectedTrademark != null)
          TrademarkInfoCard(
            selectedTrademark: selectedTrademark!,
            onMapTap: onMapTap,
            isRightMenuOpen: isRightMenuOpen,
          ),
        if (selectedIndustrialDesign != null)
          IndustrialDesignInfoCard(
            selectedIndustrialDesign: selectedIndustrialDesign!,
            onMapTap: onMapTap,
            isRightMenuOpen: isRightMenuOpen,
          ),
      ],
    );
  }
}