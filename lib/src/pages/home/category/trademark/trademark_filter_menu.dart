import 'package:flutter/material.dart';

class TrademarkFilterMenu extends StatelessWidget {
  final String? selectedType;
  final String? selectedYear;
  final String? selectedDistrict;
  final List<Map<String, dynamic>> availableTypes;
  final List<String> availableYears;
  final List<Map<String, dynamic>> availableDistricts;
  final Function(String?) onTypeChanged;
  final Function(String?) onYearChanged;
  final Function(String?) onDistrictChanged;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  const TrademarkFilterMenu({
    super.key,
    this.selectedType,
    this.selectedYear,
    this.selectedDistrict,
    required this.availableTypes,
    required this.availableYears,
    required this.availableDistricts,
    required this.onTypeChanged,
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
            const Text('Loại nhãn hiệu:'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedType,
              hint: const Text('Chọn loại nhãn hiệu'),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Tất cả'),
                ),
                ...availableTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type['type'],
                    child: Text('${type['type']} (${type['count']})'),
                  );
                }),
              ],
              onChanged: onTypeChanged,
            ),
            const SizedBox(height: 16),
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
                    child: Text('${district['district_name']} (${district['count']})'),
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