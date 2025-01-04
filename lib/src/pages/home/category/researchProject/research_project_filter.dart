import 'package:flutter/material.dart';

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
    return AlertDialog(
      title: const Text('Bộ lọc'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lĩnh vực:'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedField,
              hint: const Text('Chọn lĩnh vực'),
              items: [null, ...availableFields].map((String? value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value ?? 'Tất cả'),
                );
              }).toList(),
              onChanged: onFieldChanged,
            ),
            const SizedBox(height: 16),
            const Text('Năm:'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedYear,
              hint: const Text('Chọn năm'),
              items: [null, ...availableYears].map((String? value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value ?? 'Tất cả'),
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