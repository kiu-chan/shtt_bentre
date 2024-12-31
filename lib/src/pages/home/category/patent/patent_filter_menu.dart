// patent_filter_menu.dart
import 'package:flutter/material.dart';

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
            const SizedBox(height: 16),
            const Text('Huyện:'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedDistrict,
              hint: const Text('Chọn huyện'),
              items: [null, ...availableDistricts].map((String? value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value ?? 'Tất cả'),
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