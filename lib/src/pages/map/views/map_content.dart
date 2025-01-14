import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shtt_bentre/src/mainData/config/file_path.dart';
import 'package:shtt_bentre/src/mainData/config/map.dart';
import 'package:shtt_bentre/src/mainData/data/map/industrial_design.dart';
import 'package:shtt_bentre/src/mainData/data/map/patent.dart';
import 'package:shtt_bentre/src/mainData/data/map/trademark.dart';
import 'package:shtt_bentre/src/pages/map/map_utils.dart';

class MapContent extends StatelessWidget {
  final MapController mapController;
  final double currentZoom;
  final LatLng center;
  final MapType currentMapType;
  final bool isPatentEnabled;
  final bool isTrademarkEnabled;
  final bool isIndustrialDesignEnabled;
  final List<Patent> patents; // Thay dynamic bằng Patent
  final List<TrademarkMapModel> trademarks; // Thay dynamic bằng TrademarkMapModel 
  final List<IndustrialDesignMapModel> industrialDesigns; // Thay dynamic bằng IndustrialDesignMapModel
  final Patent? selectedPatent; // Thay dynamic bằng Patent
  final TrademarkMapModel? selectedTrademark; // Thay dynamic bằng TrademarkMapModel
  final IndustrialDesignMapModel? selectedIndustrialDesign; // Thay dynamic bằng IndustrialDesignMapModel
  final Function(Patent) onShowPatentInfo; // Thay dynamic bằng Patent
  final Function(TrademarkMapModel) onShowTrademarkInfo; // Thay dynamic bằng TrademarkMapModel
  final Function(IndustrialDesignMapModel) onShowIndustrialDesignInfo; // Thay dynamic bằng IndustrialDesignMapModel
  final Function(dynamic, dynamic) onMapTap;
  final Function(double) onZoomChanged;
  final List<Polygon> polygons;
  final List<Polyline> borderLines;

  const MapContent({
    super.key,
    required this.mapController,
    required this.currentZoom,
    required this.center,
    required this.currentMapType,
    required this.isPatentEnabled,
    required this.isTrademarkEnabled,
    required this.isIndustrialDesignEnabled,
    required this.patents,
    required this.trademarks,
    required this.industrialDesigns,
    required this.selectedPatent,
    required this.selectedTrademark,
    required this.selectedIndustrialDesign,
    required this.onShowPatentInfo,
    required this.onShowTrademarkInfo,
    required this.onShowIndustrialDesignInfo,
    required this.onMapTap,
    required this.onZoomChanged,
    required this.polygons,
    required this.borderLines,
  });

  @override
  Widget build(BuildContext context) {
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
          urlTemplate: currentMapType == MapType.streets
            ? MapConfig.streetsMapUrl
            : currentMapType == MapType.satellite
              ? MapConfig.satelliteMapUrl  
              : MapConfig.terrainMapUrl,
          userAgentPackageName: MapConfig.mapPackage,
        ),
        PolygonLayer(polygons: polygons),
        if (borderLines.isNotEmpty) PolylineLayer(polylines: borderLines),
        _buildMarkersLayer(),
      ],
    );
  }

  Widget _buildMarkersLayer() {
    return MarkerLayer(
      markers: [
        if (isPatentEnabled) ..._buildMarkers(
          patents,
          FilePath.patentPath,
          onShowPatentInfo,
          selectedPatent,
        ),
        if (isTrademarkEnabled) ..._buildMarkers(
          trademarks,
          FilePath.trademarkPath, 
          onShowTrademarkInfo,
          selectedTrademark,
        ),
        if (isIndustrialDesignEnabled) ..._buildMarkers(
          industrialDesigns,
          FilePath.industrialDesignPath,
          onShowIndustrialDesignInfo,  
          selectedIndustrialDesign,
        ),
      ],
    );
  }

  List<Marker> _buildMarkers<T>(
    List<T> items,
    String assetPath, 
    Function(T) onShowInfo,
    T? selectedItem,
  ) {
    final allPoints = items.map((item) => 
      (item as dynamic).location as LatLng
    ).toList();
    
    final visiblePoints = MapUtils.clusterPoints(allPoints, currentZoom);

    return visiblePoints.map((point) {
      final item = items.firstWhere(
        (item) => (item as dynamic).location.latitude == point.latitude &&
                  (item as dynamic).location.longitude == point.longitude
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
    }).toList();
  }
}