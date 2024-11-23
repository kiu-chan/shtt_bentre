import 'package:latlong2/latlong.dart';

class MapBorder {
  final int id;
  final List<LatLng> points;
  bool isVisible;

  MapBorder({
    required this.id,
    required this.points,
    this.isVisible = false,
  });

  MapBorder copyWith({
    int? id,
    List<LatLng>? points,
    bool? isVisible,
  }) {
    return MapBorder(
      id: id ?? this.id,
      points: points ?? this.points,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}