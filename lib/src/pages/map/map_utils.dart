import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapUtils {
  static List<Marker> clusterMarkers(List<LatLng> points, double zoom) {
    // Áp dụng thuật toán clustering để nhóm các điểm thành các cụm
    List<List<LatLng>> clusters = _clusterPoints(points, zoom);
    
    // Tính toán các điểm đại diện cho mỗi cụm
    List<Marker> markers = clusters.map((cluster) {
      LatLng center = _computeClusterCenter(cluster);
      return Marker(
        point: center,
        builder: (ctx) => Icon(Icons.location_on),
      );
    }).toList();

    return markers;
  }

  static List<List<LatLng>> _clusterPoints(List<LatLng> points, double zoom) {
    double gridSize = _getGridSize(zoom);
    Map<String, List<LatLng>> grid = {};

    for (LatLng point in points) {
      String gridKey = '${(point.latitude / gridSize).floor()},${(point.longitude / gridSize).floor()}';
      grid.putIfAbsent(gridKey, () => []).add(point);
    }

    return grid.values.toList();
  }

  static double _getGridSize(double zoom) {
    return 0.1 / (zoom - 5);
  }

  static LatLng _computeClusterCenter(List<LatLng> points) {
    double latitude = 0;
    double longitude = 0;

    for (LatLng point in points) {
      latitude += point.latitude;
      longitude += point.longitude;
    }

    return LatLng(latitude / points.length, longitude / points.length);
  }
}