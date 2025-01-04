import 'package:flutter/material.dart';

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