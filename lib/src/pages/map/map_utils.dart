import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapUtils {
  static List<LatLng> clusterPoints(List<LatLng> points, double zoom) {
    // Ở mức zoom cao, hiển thị tất cả các điểm
    if (zoom >= 14) {
      return points;
    }

    double gridSize = _getGridSize(zoom);
    Map<String, List<LatLng>> grid = {};

    // Gom nhóm các điểm vào grid
    for (LatLng point in points) {
      String gridKey = '${(point.latitude / gridSize).floor()},${(point.longitude / gridSize).floor()}';
      grid.putIfAbsent(gridKey, () => []).add(point);
    }

    // Với mỗi nhóm, chỉ lấy điểm đầu tiên làm đại diện
    return grid.values.map((cluster) => cluster.first).toList();
  }

  static double _getGridSize(double zoom) {
    // Điều chỉnh kích thước grid dựa trên mức zoom
    if (zoom <= 5) return 0.7;      // Grid lớn cho zoom thấp
    if (zoom <= 6) return 0.4;      // Grid lớn cho zoom thấp
    if (zoom <= 7) return 0.2;      // Grid lớn cho zoom thấp
    if (zoom <= 8) return 0.1;      // Grid lớn cho zoom thấp
    if (zoom <= 10) return 0.05;    // Grid trung bình
    if (zoom <= 12) return 0.02;    // Grid nhỏ cho zoom cao
    return 0.01;                    // Grid rất nhỏ cho zoom rất cao
  }
}