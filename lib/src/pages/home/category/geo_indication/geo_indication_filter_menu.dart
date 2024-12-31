import 'package:flutter/material.dart';

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
              items: [null, ...availableDistricts.map((d) => d['name'] as String)].map((String? value) {
                final district = value != null 
                    ? availableDistricts.firstWhere((d) => d['name'] == value)
                    : null;
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value != null 
                      ? '${district!['name']} (${district['count']})'
                      : 'Tất cả'),
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