import 'package:flutter/material.dart';

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
    return AlertDialog(
      title: const Text('Bộ lọc'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Năm:'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedYear,
              hint: const Text('Chọn năm'),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Tất cả'),
                ),
                ...availableYears.map((year) {
                  return DropdownMenuItem<String>(
                    value: year['year'].toString(),
                    child: Text('${year['year']} (${year['count']} hồ sơ)'),
                  );
                }),
              ],
              onChanged: onYearChanged,
            ),
            const SizedBox(height: 16),
            const Text('Lĩnh vực:'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedField,
              hint: const Text('Chọn lĩnh vực'),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Tất cả'),
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
            const Text('Giải thưởng:'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedRank,
              hint: const Text('Chọn giải thưởng'),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Tất cả'),
                ),
                ...availableRanks.map((rank) {
                  // Lưu giá trị chữ thường vào value
                  return DropdownMenuItem<String>(
                    value: rank['rank'].toString().toLowerCase(),
                    child: Text('${rank['rank']} (${rank['count']} hồ sơ)'),
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
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: onApply,
          child: const Text('Áp dụng'),
        ),
      ],
    );
  }
}