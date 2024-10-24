import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shtt_bentre/src/mainData/data/district.dart';
import 'package:shtt_bentre/src/mainData/data/commune.dart';

class MapPageView extends StatelessWidget {
  final MapController mapController;
  final double currentZoom;
  final LatLng center;
  final List<District> districts;
  final List<Commune> communes;
  final bool isLoading;
  final bool isLegendVisible;
  final bool isRightMenuOpen;
  final bool isBorderEnabled;
  final bool isCommuneEnabled;
  final bool isBorderLoading;
  final bool isCommuneLoading;
  final String? selectedDistrictName;
  final String? selectedCommuneName;
  final Animation<Offset> legendSlideAnimation;
  final VoidCallback onToggleLegend;
  final VoidCallback onToggleRightMenu;
  final VoidCallback onToggleBorder;
  final VoidCallback onToggleCommune;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final Function(String) onShowDistrictInfo;
  final Function(Commune) onShowCommuneInfo;
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
    required this.isLoading,
    required this.isLegendVisible,
    required this.isRightMenuOpen,
    required this.isBorderEnabled,
    required this.isCommuneEnabled,
    required this.isBorderLoading,
    required this.isCommuneLoading,
    required this.selectedDistrictName,
    required this.selectedCommuneName,
    required this.legendSlideAnimation,
    required this.onToggleLegend,
    required this.onToggleRightMenu,
    required this.onToggleBorder,
    required this.onToggleCommune,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onShowDistrictInfo,
    required this.onShowCommuneInfo,
    required this.onMapTap,
    required this.polygons,
    required this.borderLines,
  }) : super(key: key);

  Widget _buildLegend() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 250,
        maxHeight: 400,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.map, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Chú thích',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Huyện',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...districts.map((district) => InkWell(
                    onTap: () => onShowDistrictInfo(district.name),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 4,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: district.color,
                              border: Border.all(
                                color: district.color.withOpacity(1),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              district.name,
                              style: TextStyle(
                                fontWeight: selectedDistrictName == district.name
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                  if (isCommuneEnabled && communes.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Xã',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...communes.map((commune) => InkWell(
                      onTap: () => onShowCommuneInfo(commune),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 4,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: commune.color,
                                border: Border.all(
                                  color: commune.color.withOpacity(1),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                commune.name,
                                style: TextStyle(
                                  fontWeight: selectedCommuneName == commune.name
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightMenu(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                const Icon(Icons.layers, color: Colors.white),
                const SizedBox(width: 8),
                const Text(
                  'Điều khiển lớp bản đồ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: onToggleRightMenu,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.border_all),
                    title: const Text('Viền bản đồ'),
                    trailing: isBorderLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Switch(
                            value: isBorderEnabled,
                            onChanged: (_) => onToggleBorder(),
                          ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_city),
                    title: const Text('Ranh giới xã'),
                    trailing: isCommuneLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Switch(
                            value: isCommuneEnabled,
                            onChanged: (_) => onToggleCommune(),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPanel() {
    if (selectedCommuneName == null) return const SizedBox.shrink();

    final selectedCommune = communes.firstWhere(
      (c) => c.name == selectedCommuneName,
      orElse: () => communes.first,
    );

    return Positioned(
      top: 70,
      right: isRightMenuOpen ? 316 : 16,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(
            maxWidth: 300,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thông tin chi tiết',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => onMapTap(null, null),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 20,
                  ),
                ],
              ),
              const Divider(),
              Text(
                selectedCommune.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text('Diện tích: ${selectedCommune.area.toStringAsFixed(2)} km²'),
              Text('Dân số: ${selectedCommune.population}'),
              Text('Cập nhật: ${selectedCommune.updatedYear}'),
            ],
          ),
        ),
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(AppLocalizations.of(context)!.map),
      actions: [
        IconButton(
          icon: Icon(isLegendVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggleLegend,
          tooltip: 'Ẩn/Hiện chú thích',
        ),
        IconButton(
          icon: Icon(isRightMenuOpen ? Icons.menu_open : Icons.menu),
          onPressed: onToggleRightMenu,
          tooltip: 'Menu',
        ),
      ],
    ),
    body: Stack(
      children: [
        // Map Layer
        FlutterMap(
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
          ],
        ),

        // Legend
        if (isLegendVisible)
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: SlideTransition(
                position: legendSlideAnimation,
                child: _buildLegend(),
              ),
            ),
          ),

        // Right Menu
        AnimatedContainer(
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
            child: _buildRightMenu(context),
          ),
        ),

        // Loading Indicator
        if (isBorderLoading || isCommuneLoading)
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isBorderLoading
                            ? 'Đang tải viền bản đồ...'
                            : 'Đang tải ranh giới xã...',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // Zoom Controls
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 16,
              right: isRightMenuOpen ? 316 : 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: "zoomIn",
                  onPressed: onZoomIn,
                  tooltip: 'Phóng to',
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: "zoomOut",
                  onPressed: onZoomOut,
                  tooltip: 'Thu nhỏ',
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ),

        // Scale
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.straighten, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${currentZoom.toStringAsFixed(1)}x',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '© OpenStreetMap contributors',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}