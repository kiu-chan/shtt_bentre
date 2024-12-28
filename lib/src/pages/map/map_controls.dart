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
