import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math';

class MapZoomControls extends StatelessWidget {
  final bool isRightMenuOpen;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const MapZoomControls({
    super.key,
    required this.isRightMenuOpen,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
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
    );
  }
}

class MapScaleInfo extends StatelessWidget {
  final double currentZoom;

  const MapScaleInfo({
    super.key,
    required this.currentZoom,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
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
    );
  }
}