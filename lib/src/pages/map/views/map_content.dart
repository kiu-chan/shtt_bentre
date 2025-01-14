import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shtt_bentre/src/mainData/config/file_path.dart';
import 'package:shtt_bentre/src/mainData/config/map.dart';
import 'package:shtt_bentre/src/mainData/data/map/industrial_design.dart';
import 'package:shtt_bentre/src/mainData/data/map/map_type.dart';
import 'package:shtt_bentre/src/mainData/data/map/patent.dart';
import 'package:shtt_bentre/src/mainData/data/map/trademark.dart';
import 'package:shtt_bentre/src/mainData/data/map/district.dart';
import 'package:shtt_bentre/src/pages/map/map_utils.dart';

class MapContent extends StatelessWidget {
 final MapController mapController;
 final double currentZoom;
 final LatLng center;
 final MapType currentMapType;
 final bool isPatentEnabled;
 final bool isTrademarkEnabled;
 final bool isIndustrialDesignEnabled;
 final List<Patent> patents;
 final List<TrademarkMapModel> trademarks;
 final List<IndustrialDesignMapModel> industrialDesigns;
 final List<District> districts;
 final Patent? selectedPatent;
 final TrademarkMapModel? selectedTrademark;
 final IndustrialDesignMapModel? selectedIndustrialDesign;
 final Function(Patent) onShowPatentInfo;
 final Function(TrademarkMapModel) onShowTrademarkInfo;
 final Function(IndustrialDesignMapModel) onShowIndustrialDesignInfo;
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
   required this.districts,
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

 bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
   bool isInside = false;
   int i = 0, j = polygon.length - 1;
   
   for (; i < polygon.length; j = i++) {
     if (((polygon[i].latitude > point.latitude) != (polygon[j].latitude > point.latitude)) &&
         (point.longitude < (polygon[j].longitude - polygon[i].longitude) * 
         (point.latitude - polygon[i].latitude) / (polygon[j].latitude - polygon[i].latitude) + 
         polygon[i].longitude)) {
       isInside = !isInside;
     }
   }
   return isInside;
 }

 @override
 Widget build(BuildContext context) {
   return FlutterMap(
     mapController: mapController,
     options: MapOptions(
       center: center,
       zoom: currentZoom,
      onTap: (tapPosition, point) {
        bool foundDistrict = false;
        
        for (var district in districts) {
          for (var polygonPoints in district.polygons) {
            if (isPointInPolygon(point, polygonPoints)) {
              foundDistrict = true;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Thông tin huyện'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tên huyện: ${district.name}'),
                        const SizedBox(height: 8),
                        Text('Dân số: ${district.population} người'),
                        const SizedBox(height: 8),
                        Text('Diện tích: ${district.area} km²'),
                        const SizedBox(height: 8),
                        Text('Cập nhật lần cuối: ${district.updated_year}'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Đóng'),
                      ),
                    ],
                  );
                },
              );
              break;
            }
          }
          if (foundDistrict) break;
        }
        
        if (!foundDistrict) {
          onMapTap(tapPosition, point);
        }
      },
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