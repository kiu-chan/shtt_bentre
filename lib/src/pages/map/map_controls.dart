import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          bottom: 40, // Để nút nằm phía trên thanh bottom navigation
          right: isRightMenuOpen ? 316 : 16,
        ),
        child: Container(
          width: 40,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildZoomButton(
                onPressed: onZoomIn,
                icon: Icons.add,
                tooltip: AppLocalizations.of(context)!.zoomIn,
              ),
              Container(
                height: 1,
                color: Colors.grey.withOpacity(0.2),
              ),
              _buildZoomButton(
                onPressed: onZoomOut,
                icon: Icons.remove,
                tooltip: AppLocalizations.of(context)!.zoomOut,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZoomButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String tooltip,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Tooltip(
          message: tooltip,
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: Colors.black87,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}