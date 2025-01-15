import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductFilterMenu extends StatelessWidget {
  final String? selectedYear;
  final String? selectedDistrict;
  final List<String> availableYears;
  final List<Map<String, dynamic>> availableDistricts;
  final Function(String?) onYearChanged;
  final Function(String?) onDistrictChanged;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  const ProductFilterMenu({
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
            Text('${l10n.year}:'),
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
                    child: Text('Năm $year'),
                  );
                }),
              ],
              onChanged: onYearChanged,
            ),
            const SizedBox(height: 16),
            Text('${l10n.area}:'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedDistrict,
              hint: Text(l10n.selectArea),
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(l10n.all),
                ),
                ...availableDistricts.map((district) {
                  return DropdownMenuItem<String>(
                    value: district['district_name'],
                    child: Text('${district['district_name']} (${district['count']})')
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