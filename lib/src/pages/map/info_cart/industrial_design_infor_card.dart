// lib/src/pages/map/info_cart/industrial_design_info_card.dart

import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/industrial_design.dart';
import 'package:shtt_bentre/src/mainData/data/home/industrial_design_detail.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:shtt_bentre/src/pages/home/category/industrialDesign/industrial_design_detail_page.dart';

class IndustrialDesignInfoCard extends StatefulWidget {
  final IndustrialDesignMapModel selectedIndustrialDesign;
  final Function(dynamic, dynamic) onMapTap;
  final bool isRightMenuOpen;

  const IndustrialDesignInfoCard({
    super.key,
    required this.selectedIndustrialDesign,
    required this.onMapTap,
    required this.isRightMenuOpen,
  });

  @override
  State<IndustrialDesignInfoCard> createState() => _IndustrialDesignInfoCardState();
}

class _IndustrialDesignInfoCardState extends State<IndustrialDesignInfoCard> {
  final Database _database = Database();
  late Future<IndustrialDesignDetailModel> _designDetailFuture;

  @override
  void initState() {
    super.initState();
    _loadDesignDetails();
  }

  void _loadDesignDetails() {
    _designDetailFuture = _database.fetchIndustrialDesignDetail(
      widget.selectedIndustrialDesign.id.toString()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: 70,
          right: widget.isRightMenuOpen ? 316 : 16,
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
                _buildContent(),
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
          'THÔNG TIN KIỂU DÁNG CÔNG NGHIỆP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => widget.onMapTap(null, null),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          iconSize: 20,
        ),
      ],
    );
  }

  Widget _buildContent() {
    return FutureBuilder<IndustrialDesignDetailModel>(
      future: _designDetailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 32),
                const SizedBox(height: 8),
                Text(
                  'Lỗi: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                TextButton(
                  onPressed: _loadDesignDetails,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        final design = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoRow('Tên', design.name),
            const SizedBox(height: 8),
            _buildInfoRow('Chủ sở hữu', design.owner),
            const SizedBox(height: 8),
            _buildInfoRow('Số đơn', design.filingNumber),
            const SizedBox(height: 8),
            if (design.images.isNotEmpty) _buildImageSection(design),
            const SizedBox(height: 16),
            _buildViewDetailsButton(),
          ],
        );
      },
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

  Widget _buildImageSection(IndustrialDesignDetailModel design) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hình ảnh:',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            design.images[0].filePath,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildViewDetailsButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IndustrialDesignDetailPage(
                id: widget.selectedIndustrialDesign.id.toString(),
              ),
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