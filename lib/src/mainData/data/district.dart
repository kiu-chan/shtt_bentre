import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class District {
  final int id;
  final String name;
  final List<List<LatLng>> polygons;
  final Color color;
  bool isVisible;

  District({
    required this.id,
    required this.name,
    required this.polygons,
    required this.color,
    this.isVisible = true,
  });

  District copyWith({
    int? id,
    String? name,
    List<List<LatLng>>? polygons,
    Color? color,
    bool? isVisible,
  }) {
    return District(
      id: id ?? this.id,
      name: name ?? this.name,
      polygons: polygons ?? this.polygons,
      color: color ?? this.color,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}