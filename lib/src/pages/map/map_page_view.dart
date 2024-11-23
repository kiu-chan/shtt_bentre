import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shtt_bentre/src/mainData/data/map/commune.dart';
import 'package:shtt_bentre/src/mainData/data/map/district.dart';
import 'package:shtt_bentre/src/mainData/data/patent.dart';
import 'package:shtt_bentre/src/pages/map/legend.dart';
import 'package:shtt_bentre/src/pages/map/loading_indicator.dart';
import 'package:shtt_bentre/src/pages/map/map_controls.dart';
import 'package:shtt_bentre/src/pages/map/map_info_cards.dart';
import 'package:shtt_bentre/src/pages/map/right_menu.dart';

class MapPageView extends StatelessWidget {
  final MapController mapController;
  final double currentZoom;
  final LatLng center;
  final List<District> districts;
  final List<Commune> communes;
  final List<Patent> patents;
  
  final bool isLoading;
  final bool isLegendVisible;
  final bool isRightMenuOpen;
  final bool isBorderEnabled;
  final bool isCommuneEnabled;
  final bool isDistrictEnabled;
  final bool isPatentEnabled;
  final bool isBorderLoading;
  final bool isCommuneLoading;
  final bool isPatentLoading;
  
  final String? selectedDistrictName;
  final String? selectedCommuneName;
  final Patent? selectedPatent;
  
  final Animation<Offset> legendSlideAnimation;
  
  // Cập nhật các callback để có thể null
  final VoidCallback? onToggleLegend;
  final VoidCallback onToggleRightMenu;
  final VoidCallback? onToggleBorder;
  final VoidCallback? onToggleCommune;
  final VoidCallback? onToggleDistrict;
  final VoidCallback? onTogglePatent;
  final Function(int) onToggleDistrictVisibility;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final Function(String) onShowDistrictInfo;
  final Function(Commune) onShowCommuneInfo;
  final Function(Patent) onShowPatentInfo;
  final Function(dynamic, dynamic) onMapTap;
  
  final List<Polygon> polygons;
  final List<Polyline> borderLines;

  const MapPageView({
    Key? key,
    required this.mapController,
    required this.currentZoom,
    required this.center,
    required this.districts,
    required this.communes,
    required this.patents,
    required this.isLoading,
    required this.isLegendVisible,
    required this.isRightMenuOpen,
    required this.isBorderEnabled,
    required this.isCommuneEnabled,
    required this.isDistrictEnabled,
    required this.isPatentEnabled,
    required this.isBorderLoading,
    required this.isCommuneLoading,
    required this.isPatentLoading,
    required this.selectedDistrictName,
    required this.selectedCommuneName,
    required this.selectedPatent,
    required this.legendSlideAnimation,
    required this.onToggleLegend,
    required this.onToggleRightMenu,
    required this.onToggleBorder,
    required this.onToggleCommune,
    required this.onToggleDistrict,
    required this.onTogglePatent,
    required this.onToggleDistrictVisibility,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onShowDistrictInfo,
    required this.onShowCommuneInfo,
    required this.onShowPatentInfo,
    required this.onMapTap,
    required this.polygons,
    required this.borderLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          _buildMap(),
          _buildLegend(context),
          _buildRightMenuContainer(),
          _buildInfoCards(),
          MapZoomControls(
            isRightMenuOpen: isRightMenuOpen,
            onZoomIn: onZoomIn,
            onZoomOut: onZoomOut,
          ),
          MapScaleInfo(currentZoom: currentZoom),
          LoadingIndicator(
            isBorderLoading: isBorderLoading,
            isCommuneLoading: isCommuneLoading,
            isPatentLoading: isPatentLoading,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.map),
      actions: [
        IconButton(
          icon: Icon(isLegendVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggleLegend, // Có thể null
          tooltip: AppLocalizations.of(context)!.hide_ShowLegend,
        ),
        IconButton(
          icon: Icon(isRightMenuOpen ? Icons.menu_open : Icons.menu),
          onPressed: onToggleRightMenu,
          tooltip: AppLocalizations.of(context)!.menu,
        ),
      ],
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: center,
        zoom: currentZoom,
        onTap: onMapTap,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        PolygonLayer(polygons: polygons),
        if (borderLines.isNotEmpty) PolylineLayer(polylines: borderLines),
        if (isPatentEnabled) _buildPatentMarkers(),
      ],
    );
  }

  Widget _buildPatentMarkers() {
    return MarkerLayer(
      markers: patents.map((patent) => Marker(
        width: 30.0,
        height: 30.0,
        point: patent.location,
        builder: (ctx) => GestureDetector(
          onTap: () => onShowPatentInfo(patent),
          child: Icon(
            Icons.lightbulb,
            color: selectedPatent?.id == patent.id ? Colors.orange : Colors.blue,
            size: selectedPatent?.id == patent.id ? 30 : 24,
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildLegend(BuildContext context) {
    if (!isLegendVisible) return const SizedBox.shrink();
    
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 16),
        child: SlideTransition(
          position: legendSlideAnimation,
          child: MapLegend(
            districts: districts,
            communes: communes,
            patents: patents,
            isDistrictEnabled: isDistrictEnabled,
            isCommuneEnabled: isCommuneEnabled,
            isPatentEnabled: isPatentEnabled,
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
          isBorderLoading: isBorderLoading,
          isCommuneLoading: isCommuneLoading,
          isPatentLoading: isPatentLoading,
          onToggleRightMenu: onToggleRightMenu,
          onToggleBorder: onToggleBorder,
          onToggleCommune: onToggleCommune,
          onToggleDistrict: onToggleDistrict,
          onTogglePatent: onTogglePatent,
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
      ],
    );
  }
}