import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shtt_bentre/src/mainData/data/map/district.dart';

class MapRightMenu extends StatelessWidget {
  final List<District> districts;
  final bool isDistrictEnabled;
  final bool isBorderEnabled;
  final bool isCommuneEnabled;
  final bool isPatentEnabled;
  final bool isTrademarkEnabled;
  final bool isBorderLoading;
  final bool isCommuneLoading;
  final bool isPatentLoading;
  final bool isTrademarkLoading;
  final bool isIndustrialDesignEnabled;
  final bool isIndustrialDesignLoading;
  final VoidCallback onToggleRightMenu;
  final VoidCallback? onToggleBorder;
  final VoidCallback? onToggleCommune;
  final VoidCallback? onToggleDistrict;
  final VoidCallback? onTogglePatent;
  final VoidCallback? onToggleTrademark;
  final VoidCallback? onToggleIndustrialDesign;
  final Function(int) onToggleDistrictVisibility;

  const MapRightMenu({
    super.key,
    required this.districts,
    required this.isDistrictEnabled,
    required this.isBorderEnabled,
    required this.isCommuneEnabled,
    required this.isPatentEnabled,
    required this.isTrademarkEnabled,
    required this.isBorderLoading,
    required this.isCommuneLoading,
    required this.isPatentLoading,
    required this.isTrademarkLoading,
    required this.onToggleRightMenu,
    required this.onToggleBorder,
    required this.onToggleCommune,
    required this.onToggleDistrict,
    required this.onTogglePatent,
    required this.onToggleTrademark,
    required this.onToggleDistrictVisibility, 
    required this.isIndustrialDesignEnabled, 
    required this.isIndustrialDesignLoading, 
    this.onToggleIndustrialDesign,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildLayerControls(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
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
            tooltip: AppLocalizations.of(context)!.close,
          ),
        ],
      ),
    );
  }

  Widget _buildLayerControls(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLayerSwitches(context),
        ],
      ),
    );
  }

  Widget _buildLayerSwitches(BuildContext context) {
    return Column(
      children: [
        _buildLayerSwitch(
          context,
          icon: Icons.map,
          title: AppLocalizations.of(context)!.mapDistrict,
          value: isDistrictEnabled,
          onChanged: onToggleDistrict,
          isLoading: false,
        ),
        const SizedBox(height: 4),
        _buildLayerSwitch(
          context,
          icon: Icons.border_all,
          title: AppLocalizations.of(context)!.mapBorder,
          value: isBorderEnabled,
          onChanged: onToggleBorder,
          isLoading: isBorderLoading,
        ),
        const SizedBox(height: 4),
        _buildLayerSwitch(
          context,
          icon: Icons.location_city,
          title: AppLocalizations.of(context)!.mapCommune,
          value: isCommuneEnabled,
          onChanged: onToggleCommune,
          isLoading: isCommuneLoading,
        ),
        const SizedBox(height: 4),
        _buildLayerSwitch(
          context,
          icon: Icons.lightbulb,
          title: 'Bằng sáng chế',
          value: isPatentEnabled,
          onChanged: onTogglePatent,
          isLoading: isPatentLoading,
        ),
        const SizedBox(height: 4),
        _buildLayerSwitch(
          context,
          icon: Icons.bookmark,
          title: 'Nhãn hiệu',
          value: isTrademarkEnabled,
          onChanged: onToggleTrademark,
          isLoading: isTrademarkLoading,
        ),        
        const SizedBox(height: 4),
        _buildLayerSwitch(
          context,
          icon: Icons.design_services,
          title: 'Kiểu dáng công nghiệp',
          value: isIndustrialDesignEnabled,
          onChanged: onToggleIndustrialDesign,
          isLoading: isIndustrialDesignLoading,
        ),
      ],
    );
  }

  Widget _buildLayerSwitch(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required VoidCallback? onChanged,
    required bool isLoading,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      elevation: 2,
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        trailing: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              )
            : Switch(
                value: value,
                onChanged: onChanged != null ? (_) => onChanged() : null,
                activeColor: Theme.of(context).primaryColor,
              ),
      ),
    );
  }
}