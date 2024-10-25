import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shtt_bentre/src/mainData/data/commune.dart';
import 'package:shtt_bentre/src/mainData/data/district.dart';

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
  final bool isDistrictEnabled;
  final bool isBorderLoading;
  final bool isCommuneLoading;
  final String? selectedDistrictName;
  final String? selectedCommuneName;
  final Animation<Offset> legendSlideAnimation;
  final VoidCallback onToggleLegend;
  final VoidCallback onToggleRightMenu;
  final VoidCallback onToggleBorder;
  final VoidCallback onToggleCommune;
  final VoidCallback onToggleDistrict;
  final Function(int) onToggleDistrictVisibility;
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
    required this.isDistrictEnabled,
    required this.isBorderLoading,
    required this.isCommuneLoading,
    required this.selectedDistrictName,
    required this.selectedCommuneName,
    required this.legendSlideAnimation,
    required this.onToggleLegend,
    required this.onToggleRightMenu,
    required this.onToggleBorder,
    required this.onToggleCommune,
    required this.onToggleDistrict,
    required this.onToggleDistrictVisibility,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onShowDistrictInfo,
    required this.onShowCommuneInfo,
    required this.onMapTap,
    required this.polygons,
    required this.borderLines,
  }) : super(key: key);

  Widget _buildLegend(BuildContext context) {
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
            child: Row(
              children: [
                const Icon(Icons.map, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.notes,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (isDistrictEnabled)
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                itemCount: districts.length,
                itemBuilder: (context, index) {
                  final district = districts[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onShowDistrictInfo(district.name),
                      child: Opacity(
                        opacity: district.isVisible ? 1.0 : 0.5,
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
                              IconButton(
                                icon: Icon(
                                  district.isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 18,
                                ),
                                onPressed: () => onToggleDistrictVisibility(index),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          if (isCommuneEnabled && communes.isNotEmpty) ...[
            const Divider(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.location_city, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    AppLocalizations.of(context)!.communes,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                itemCount: communes.length,
                itemBuilder: (context, index) {
                  final commune = communes[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onShowCommuneInfo(commune),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 4,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
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
                                  fontSize: 13,
                                  fontWeight: selectedCommuneName == commune.name
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
                Text(
                  AppLocalizations.of(context)!.mapControl,
                  style: const TextStyle(
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
                    leading: const Icon(Icons.map),
                    title: Text(AppLocalizations.of(context)!.mapDistrict),
                    trailing: Switch(
                      value: isDistrictEnabled,
                      onChanged: (_) => onToggleDistrict(),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.border_all),
                    title: Text(AppLocalizations.of(context)!.mapBorder),
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
                    title: Text(AppLocalizations.of(context)!.mapCommune),
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
                if (isDistrictEnabled) ...[
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.displayDistrictControl,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ...districts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final district = entry.value;
                    return Card(
                      child: SwitchListTile(
                        title: Text(district.name),
                        value: district.isVisible,
                        onChanged: (_) => onToggleDistrictVisibility(index),
                        secondary: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: district.color,
                            border: Border.all(
                              color: district.color.withOpacity(1),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ],
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
            tooltip: AppLocalizations.of(context)!.hide_ShowLegend,
          ),
          IconButton(
            icon: Icon(isRightMenuOpen ? Icons.menu_open : Icons.menu),
            onPressed: onToggleRightMenu,
            tooltip: AppLocalizations.of(context)!.menu,
          ),
        ],
      ),
      body: Stack(
        children: [
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
              PolygonLayer(
                polygons: polygons,
              ),
              if (borderLines.isNotEmpty)
                PolylineLayer(
                  polylines: borderLines,
                ),
            ],
          ),
          if (isLegendVisible)
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: SlideTransition(
                  position: legendSlideAnimation,
                  child: _buildLegend(context),
                ),
              ),
            ),
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
                              ? AppLocalizations.of(context)!.loadingMapBoundary
                              : AppLocalizations.of(context)!.loadingCommuneBoundaries,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
                    tooltip: AppLocalizations.of(context)!.zoomIn,
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    heroTag: "zoomOut",
                    onPressed: onZoomOut,
                    tooltip: AppLocalizations.of(context)!.zoomOut,
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
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
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 50,
                          height: 2,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(5000 / pow(2, currentZoom)).round()} m',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.linkMapApi,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (selectedCommuneName != null)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 70,
                  right: isRightMenuOpen ? 316 : 16,
                ),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(
                      maxWidth: 300,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.detailedInformation,
                              style: const TextStyle(
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
                        ...communes
                            .where((c) => c.name == selectedCommuneName)
                            .map((commune) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                commune.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${AppLocalizations.of(context)!.area}: ${commune.area.toStringAsFixed(2)} km²'
                              ),
                              Text('${AppLocalizations.of(context)!.population}: ${commune.population}'),
                              Text('${AppLocalizations.of(context)!.update}: ${commune.updatedYear}'),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}