import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shtt_bentre/src/mainData/config/file_path.dart';
import 'package:shtt_bentre/src/mainData/data/industrial_design.dart';
import 'package:shtt_bentre/src/mainData/data/map/commune.dart';
import 'package:shtt_bentre/src/mainData/data/map/district.dart';
import 'package:shtt_bentre/src/mainData/data/patent.dart';
import 'package:shtt_bentre/src/mainData/data/trademark.dart';

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
          _buildLegendHeader(context),
          if (isDistrictEnabled) _buildDistrictsList(),
          if (isIndustrialDesignEnabled && industrialDesigns.isNotEmpty) ...[
            const Divider(),
            _buildIndustrialDesignsSection(),
          ],
          if (isPatentEnabled && patents.isNotEmpty) ...[
            const Divider(),
            _buildPatentsSection(),
          ],
          if (isTrademarkEnabled && trademarks.isNotEmpty) ...[
            const Divider(),
            _buildTrademarksSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildLegendHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
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
    );
  }

  Widget _buildDistrictsList() {
    return Flexible(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        itemCount: districts.length,
        itemBuilder: (context, index) => _buildDistrictItem(districts[index], index),
      ),
    );
  }

  Widget _buildDistrictItem(District district, int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onShowDistrictInfo(district.name),
        child: Opacity(
          opacity: district.isVisible ? 1.0 : 0.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: district.color,
                    border: Border.all(color: district.color.withOpacity(1)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    district.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: selectedDistrictName == district.name
                          ? FontWeight.bold
                          : FontWeight.normal,
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

  Widget _buildIndustrialDesignsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: Image.asset(
                  'lib/assets/map/industrial_design.png',
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'Kiểu dáng công nghiệp',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: Image.asset(
                  FilePath.industrialDesignPath,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Vị trí kiểu dáng công nghiệp',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPatentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: Image.asset(
                  FilePath.patentPath,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'Bằng sáng chế',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: Image.asset(
                  FilePath.patentPath,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Vị trí bằng sáng chế',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrademarksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: Image.asset(
                  FilePath.trademarkPath,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'Nhãn hiệu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: Image.asset(
                  FilePath.trademarkPath,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Vị trí nhãn hiệu',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}