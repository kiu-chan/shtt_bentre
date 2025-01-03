import 'package:flutter/material.dart';

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
                    value: year,
                    child: Text('Năm $year'),
                  );
                }),
              ],
              onChanged: onYearChanged,
            ),
            const SizedBox(height: 16),
            const Text('Địa bàn:'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedDistrict,
              hint: const Text('Chọn địa bàn'),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Tất cả'),
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