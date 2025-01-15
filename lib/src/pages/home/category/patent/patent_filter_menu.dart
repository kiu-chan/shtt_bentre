import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatentFilterMenu extends StatelessWidget {
  final String? selectedField;
  final String? selectedYear;
  final String? selectedDistrict;
  final Set<String> availableFields;
  final Set<String> availableYears;
  final Set<String> availableDistricts;
  final Function(String?) onFieldChanged;
  final Function(String?) onYearChanged;
  final Function(String?) onDistrictChanged;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  const PatentFilterMenu({
    super.key,
    this.selectedField,
    this.selectedYear,
    this.selectedDistrict,
    required this.availableFields,
    required this.availableYears,
    required this.availableDistricts,
    required this.onFieldChanged,
    required this.onYearChanged,
    required this.onDistrictChanged,
    required this.onApply,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.filter),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${AppLocalizations.of(context)!.field}:'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedField,
              hint: Text(AppLocalizations.of(context)!.selectField),
              items: [null, ...availableFields].map((String? value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value ?? AppLocalizations.of(context)!.all),
                );
              }).toList(),
              onChanged: onFieldChanged,
            ),
            const SizedBox(height: 16),
            Text('${AppLocalizations.of(context)!.year}:'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedYear,
              hint: Text(AppLocalizations.of(context)!.selectYear),
              items: [null, ...availableYears].map((String? value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value ?? AppLocalizations.of(context)!.all),
                );
              }).toList(),
              onChanged: onYearChanged,
            ),
            const SizedBox(height: 16),
            Text('${AppLocalizations.of(context)!.districtLabel}:'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedDistrict,
              hint: Text(AppLocalizations.of(context)!.selectDistrict),
              items: [null, ...availableDistricts].map((String? value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value ?? AppLocalizations.of(context)!.all),
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
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: onApply,
          child: Text(AppLocalizations.of(context)!.apply),
        ),
      ],
    );
  }
}