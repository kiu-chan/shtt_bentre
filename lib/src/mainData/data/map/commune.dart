import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Commune {
  final int id;
  final String name;
  final int districtId;
  final List<List<LatLng>> polygons;
  final Color color;
  bool isVisible;
  final double area;
  final int population;
  final String updatedYear;

  Commune({
    required this.id,
    required this.name,
    required this.districtId,
    required this.polygons,
    required this.color,
    required this.area,
    required this.population,
    required this.updatedYear,
    this.isVisible = false,
  });

  Commune copyWith({
    int? id,
    String? name,
    int? districtId,
    List<List<LatLng>>? polygons,
    Color? color,
    bool? isVisible,
    double? area,
    int? population,
    String? updatedYear,
  }) {
    return Commune(
      id: id ?? this.id,
      name: name ?? this.name,
      districtId: districtId ?? this.districtId,
      polygons: polygons ?? this.polygons,
      color: color ?? this.color,
      isVisible: isVisible ?? this.isVisible,
      area: area ?? this.area,
      population: population ?? this.population,
      updatedYear: updatedYear ?? this.updatedYear,
    );
  }
}