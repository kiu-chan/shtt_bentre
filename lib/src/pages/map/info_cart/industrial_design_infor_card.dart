import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/map/industrial_design.dart';
import 'package:shtt_bentre/src/mainData/data/home/industrialDesign/industrial_design_detail.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:shtt_bentre/src/pages/home/category/industrialDesign/industrial_design_detail_page.dart';
import 'package:shtt_bentre/src/pages/map/info_cart/info_card_base.dart';

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
      widget.selectedIndustrialDesign.id.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InfoCardBase(
      title: 'KIỂU DÁNG CÔNG NGHIỆP',
      isRightMenuOpen: widget.isRightMenuOpen,
      onMapTap: widget.onMapTap,
      content: _buildContent(),
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
            InfoCardRow(
              label: 'Tên',
              value: design.name,
              useColumn: true,
            ),
            const SizedBox(height: 8),
            InfoCardRow(
              label: 'Chủ sở hữu',
              value: design.owner,
              useColumn: true,
            ),
            const SizedBox(height: 8),
            InfoCardRow(
              label: 'Số đơn',
              value: design.filingNumber,
              useColumn: true,
            ),
            const SizedBox(height: 8),
            if (design.images.isNotEmpty)
              InfoCardImageSection(imageUrl: 'https://shttbentre.girc.edu.vn/storage/${design.images[0].filePath}'),
            const SizedBox(height: 16),
            InfoCardDetailButton(
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
            ),
          ],
        );
      },
    );
  }
}