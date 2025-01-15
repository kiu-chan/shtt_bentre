import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrademarkFilterMenu extends StatelessWidget {
  final String? selectedType;
  final String? selectedYear;
  final String? selectedDistrict;
  final List<Map<String, dynamic>> availableTypes;
  final List<String> availableYears;
  final List<Map<String, dynamic>> availableDistricts;
  final Function(String?) onTypeChanged;
  final Function(String?) onYearChanged;
  final Function(String?) onDistrictChanged;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  const TrademarkFilterMenu({
    super.key,
    this.selectedType,
    this.selectedYear,
    this.selectedDistrict,
    required this.availableTypes,
    required this.availableYears,
    required this.availableDistricts,
    required this.onTypeChanged,
    required this.onYearChanged,
    required this.onDistrictChanged,
    required this.onApply,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.filter),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.trademarkType),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedType,
              hint: Text(l10n.selectTrademarkType),
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(l10n.all),
                ),
                ...availableTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type['type'],
                    child: Text('${type['type']} (${type['count']})'),
                  );
                }),
              ],
              onChanged: onTypeChanged,
            ),
            const SizedBox(height: 16),
            Text(l10n.year),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedYear,
              hint: Text(l10n.selectYear),
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(l10n.all),
                ),
                ...availableYears.map((year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text('${l10n.year} $year'),
                  );
                }),
              ],
              onChanged: onYearChanged,
            ),
            const SizedBox(height: 16),
            Text(l10n.district),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedDistrict,
              hint: Text(l10n.selectDistrict),
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(l10n.all),
                ),
                ...availableDistricts.map((district) {
                  return DropdownMenuItem<String>(
                    value: district['district_name'],
                    child: Text('${district['district_name']} (${district['count']})'),
                  );
                }),
              ],
              onChanged: onDistrictChanged,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: onApply,
          child: Text(l10n.apply),
        ),
      ],
    );
  }
}