import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GeoIndicationFilterMenu extends StatelessWidget {
  final String? selectedYear;
  final String? selectedDistrict;
  final List<String> availableYears;
  final List<Map<String, dynamic>> availableDistricts;
  final Function(String?) onYearChanged;
  final Function(String?) onDistrictChanged;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  const GeoIndicationFilterMenu({
    super.key,
    this.selectedYear,
    this.selectedDistrict,
    required this.availableYears,
    required this.availableDistricts,
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
            Text(l10n.year),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedYear,
              hint: Text(l10n.selectYear),
              items: [null, ...availableYears].map((String? value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value ?? l10n.all),
                );
              }).toList(),
              onChanged: onYearChanged,
            ),
            const SizedBox(height: 16),
            Text(l10n.districtLabel),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedDistrict,
              hint: Text(l10n.selectDistrict),
              items: [null, ...availableDistricts.map((d) => d['name'] as String)].map((String? value) {
                final district = value != null 
                    ? availableDistricts.firstWhere((d) => d['name'] == value)
                    : null;
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value != null 
                      ? '${district!['name']} (${district['count']})'
                      : l10n.all),
                );
              }).toList(),
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