import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InitiativeFilterMenu extends StatelessWidget {
  final String? selectedYear;
  final List<String> availableYears;
  final Function(String?) onYearChanged;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  const InitiativeFilterMenu({
    super.key,
    this.selectedYear,
    required this.availableYears,
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