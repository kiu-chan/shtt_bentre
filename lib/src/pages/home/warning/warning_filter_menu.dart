import 'package:flutter/material.dart';

class WarningFilterMenu extends StatelessWidget {
  final String? selectedStatus;
  final String? selectedAssetType;
  final String? selectedType;
  final Function(String?) onStatusChanged;
  final Function(String?) onAssetTypeChanged;
  final Function(String?) onTypeChanged;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  const WarningFilterMenu({
    super.key,
    this.selectedStatus,
    this.selectedAssetType,
    this.selectedType,
    required this.onStatusChanged,
    required this.onAssetTypeChanged,
    required this.onTypeChanged,
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
            const Text('Trạng thái:'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedStatus,
              hint: const Text('Chọn trạng thái'),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Tất cả'),
                ),
                ...['pending', 'completed', 'rejected'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(_getStatusText(value)),
                  );
                }),
              ],
              onChanged: onStatusChanged,
            ),
            const SizedBox(height: 16),
            const Text('Loại tài sản:'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedAssetType,
              hint: const Text('Chọn loại tài sản'),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Tất cả'),
                ),
                ...['Sáng chế', 'Nhãn hiệu'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }),
              ],
              onChanged: onAssetTypeChanged,
            ),
            const SizedBox(height: 16),
            const Text('Loại cảnh báo:'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedType,
              hint: const Text('Chọn loại cảnh báo'),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Tất cả'),
                ),
                ...['report', 'alert'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(_getTypeText(value)),
                  );
                }),
              ],
              onChanged: onTypeChanged,
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

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'ĐANG CHỜ';
      case 'completed':
        return 'HOÀN THÀNH';
      case 'rejected':
        return 'TỪ CHỐI';
      default:
        return status.toUpperCase();
    }
  }

  String _getTypeText(String type) {
    switch (type.toLowerCase()) {
      case 'alert':
        return 'CẢNH BÁO';
      case 'report':
        return 'BÁO CÁO';
      default:
        return type.toUpperCase();
    }
  }
}