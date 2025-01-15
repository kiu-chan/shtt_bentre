import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResearchProjectFilterMenu extends StatelessWidget {
  final String? selectedField;
  final String? selectedYear;
  final List<String> availableFields;
  final List<String> availableYears;
  final Function(String?) onFieldChanged;
  final Function(String?) onYearChanged;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  const ResearchProjectFilterMenu({
    super.key,
    this.selectedField,
    this.selectedYear,
    required this.availableFields,
    required this.availableYears,
    required this.onFieldChanged,
    required this.onYearChanged,
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
            Text('${l10n.fieldLabel}:'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedField,
              hint: Text(l10n.selectField),
              items: [null, ...availableFields].map((String? value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value ?? l10n.all),
                );
              }).toList(),
              onChanged: onFieldChanged,
            ),
            const SizedBox(height: 16),
            Text('${l10n.year}:'),
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