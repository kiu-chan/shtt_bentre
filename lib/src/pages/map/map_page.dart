import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  // Ben Tre city coordinates
  final LatLng _center = LatLng(10.2433, 106.3752);
  final MapController _mapController = MapController();
  double _currentZoom = 13.0;

  void _zoomIn() {
    _currentZoom = _currentZoom + 0.5;
    _mapController.move(_center, _currentZoom);
  }

  void _zoomOut() {
    _currentZoom = _currentZoom - 0.5;
    _mapController.move(_center, _currentZoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.map),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _center,
              zoom: _currentZoom,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _center,
                    builder: (ctx) => const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "zoomIn",
                  onPressed: _zoomIn,
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: "zoomOut",
                  onPressed: _zoomOut,
                  child: Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}