import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/trademark.dart';
import 'package:shtt_bentre/src/pages/home/category/trademark/trademark_detail.dart';

class TrademarkInfoCard extends StatelessWidget {
  final TrademarkMapModel selectedTrademark;
  final Function(dynamic, dynamic) onMapTap;
  final bool isRightMenuOpen;

  const TrademarkInfoCard({
    super.key,
    required this.selectedTrademark,
    required this.onMapTap,
    required this.isRightMenuOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: 70,
          right: isRightMenuOpen ? 316 : 16,
        ),
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const Divider(),
                _buildContent(context),
                const SizedBox(height: 16),
                _buildViewDetailsButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'THÔNG TIN NHÃN HIỆU',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => onMapTap(null, null),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          iconSize: 20,
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Tên nhãn hiệu', selectedTrademark.mark),
        const SizedBox(height: 8),
        _buildInfoRow('Chủ sở hữu', selectedTrademark.owner),
        const SizedBox(height: 8),
        _buildInfoRow('Địa chỉ', selectedTrademark.address),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildViewDetailsButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrademarkDetailPage(id: selectedTrademark.id),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E88E5),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.remove_red_eye, size: 20),
            SizedBox(width: 8),
            Text(
              'Xem chi tiết',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}