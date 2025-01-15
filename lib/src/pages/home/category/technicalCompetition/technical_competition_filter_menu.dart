import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TechnicalCompetitionFilterMenu extends StatelessWidget {
  final String? selectedYear;
  final String? selectedField;
  final String? selectedRank;
  final List<Map<String, dynamic>> availableYears;
  final List<Map<String, dynamic>> availableFields;
  final List<Map<String, dynamic>> availableRanks;
  final Function(String?) onYearChanged;
  final Function(String?) onFieldChanged;
  final Function(String?) onRankChanged;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  const TechnicalCompetitionFilterMenu({
    super.key,
    this.selectedYear,
    this.selectedField,
    this.selectedRank,
    required this.availableYears,
    required this.availableFields,
    required this.availableRanks,
    required this.onYearChanged,
    required this.onFieldChanged,
    required this.onRankChanged,
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
                    value: year['year'].toString(),
                    child: Text('${year['year']} (${year['count']} ${l10n.awardCount})'),
                  );
                }),
              ],
              onChanged: onYearChanged,
            ),
            const SizedBox(height: 16),
            Text('${l10n.fieldLabel}:'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedField,
              hint: Text(l10n.selectField),
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(l10n.all),
                ),
                ...availableFields.map((field) {
                  return DropdownMenuItem<String>(
                    value: field['field'],
                    child: Text('${field['field']} (${field['count']} hồ sơ)'),
                  );
                }),
              ],
              onChanged: onFieldChanged,
            ),
            const SizedBox(height: 16),
            Text(l10n.rank),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedRank,
              hint: Text(l10n.selectRank),
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(l10n.all),
                ),
                ...availableRanks.map((rank) {
                  // Lưu giá trị chữ thường vào value
                  return DropdownMenuItem<String>(
                    value: rank['rank'].toString().toLowerCase(),
                    child: Text('${rank['rank']} (${rank['count']} ${l10n.awardCount})'),
                  );
                }),
              ],
              onChanged: onRankChanged,
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