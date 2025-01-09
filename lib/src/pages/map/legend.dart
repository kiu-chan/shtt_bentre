import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shtt_bentre/src/mainData/config/file_path.dart';
import 'package:shtt_bentre/src/mainData/data/map/industrial_design.dart';
import 'package:shtt_bentre/src/mainData/data/map/commune.dart';
import 'package:shtt_bentre/src/mainData/data/map/district.dart';
import 'package:shtt_bentre/src/mainData/data/map/patent.dart';
import 'package:shtt_bentre/src/mainData/data/map/trademark.dart';

class MapLegend extends StatelessWidget {
  final List<District> districts;
  final List<Commune> communes;
  final List<Patent> patents;
  final List<TrademarkMapModel> trademarks;
  final List<IndustrialDesignMapModel> industrialDesigns;
  final bool isDistrictEnabled;
  final bool isCommuneEnabled;
  final bool isPatentEnabled;
  final bool isTrademarkEnabled;
  final bool isIndustrialDesignEnabled;
  final String? selectedDistrictName;
  final String? selectedCommuneName;
  final Function(int) onToggleDistrictVisibility;
  final Function(String) onShowDistrictInfo;
  final Function(Commune) onShowCommuneInfo;

  const MapLegend({
    super.key,
    required this.districts,
    required this.communes,
    required this.patents,
    required this.trademarks,
    required this.industrialDesigns,
    required this.isDistrictEnabled,
    required this.isCommuneEnabled,
    required this.isPatentEnabled,
    required this.isTrademarkEnabled,
    required this.isIndustrialDesignEnabled,
    required this.selectedDistrictName,
    required this.selectedCommuneName,
    required this.onToggleDistrictVisibility,
    required this.onShowDistrictInfo,
    required this.onShowCommuneInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 280,
        maxHeight: 500,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLegendHeader(context),
          if (isDistrictEnabled) _buildDistrictsList(),
          if (isIndustrialDesignEnabled && industrialDesigns.isNotEmpty) ...[
            const Divider(height: 1),
            _buildCategorySection(
              title: 'Kiểu dáng công nghiệp',
              iconPath: FilePath.industrialDesignPath,
              color: const Color(0xFF6750A4),
              count: industrialDesigns.length,
            ),
          ],
          if (isPatentEnabled && patents.isNotEmpty) ...[
            const Divider(height: 1),
            _buildCategorySection(
              title: 'Bằng sáng chế',
              iconPath: FilePath.patentPath,
              color: Colors.green,
              count: patents.length,
            ),
          ],
          if (isTrademarkEnabled && trademarks.isNotEmpty) ...[
            const Divider(height: 1),
            _buildCategorySection(
              title: 'Nhãn hiệu',
              iconPath: FilePath.trademarkPath,
              color: const Color(0xFF1A73E8),
              count: trademarks.length,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegendHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          const Icon(Icons.map, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            AppLocalizations.of(context)!.notes,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistrictsList() {
    return Flexible(
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        shrinkWrap: true,
        itemCount: districts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 4),
        itemBuilder: (context, index) => _buildDistrictItem(districts[index], index),
      ),
    );
  }

  Widget _buildDistrictItem(District district, int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onShowDistrictInfo(district.name),
        borderRadius: BorderRadius.circular(8),
        child: Opacity(
          opacity: district.isVisible ? 1.0 : 0.5,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: selectedDistrictName == district.name
                  ? district.color.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: district.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    district.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selectedDistrictName == district.name
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required String iconPath,
    required Color color,
    required int count,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Image.asset(
                  iconPath,
                  // color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}