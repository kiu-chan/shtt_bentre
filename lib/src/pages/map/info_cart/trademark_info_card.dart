import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/home/trademark/trademark_detail.dart';
import 'package:shtt_bentre/src/mainData/data/map/trademark.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:shtt_bentre/src/pages/home/category/trademark/trademark_detail.dart';
import 'package:shtt_bentre/src/pages/map/info_cart/info_card_base.dart';

class TrademarkInfoCard extends StatefulWidget {
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
  State<TrademarkInfoCard> createState() => _TrademarkInfoCardState();
}

class _TrademarkInfoCardState extends State<TrademarkInfoCard> {
  final Database _database = Database();
  late Future<TrademarkDetailModel> _trademarkDetailFuture;

  @override
  void initState() {
    super.initState();
    _loadTrademarkDetails();
  }

  void _loadTrademarkDetails() {
    _trademarkDetailFuture = _database.fetchTrademarkDetail(widget.selectedTrademark.id);
  }

  @override
  Widget build(BuildContext context) {
    return InfoCardBase(
      title: 'NHÃN HIỆU',
      isRightMenuOpen: widget.isRightMenuOpen,
      onMapTap: widget.onMapTap,
      content: _buildContent(),
    );
  }

  Widget _buildContent() {
    return FutureBuilder<TrademarkDetailModel>(
      future: _trademarkDetailFuture,
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
                  onPressed: _loadTrademarkDetails,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        final trademark = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InfoCardRow(
              label: 'Tên nhãn hiệu',
              value: trademark.mark,
              useColumn: true,
            ),
            const SizedBox(height: 8),
            InfoCardRow(
              label: 'Chủ sở hữu',
              value: trademark.owner,
              useColumn: true,
            ),
            const SizedBox(height: 8),
            InfoCardRow(
              label: 'Số đơn',
              value: trademark.filingNumber,
              useColumn: true,
            ),
            const SizedBox(height: 8),
            InfoCardImageSection(imageUrl: trademark.imageUrl),
            const SizedBox(height: 16),
            InfoCardDetailButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrademarkDetailPage(
                      id: widget.selectedTrademark.id,
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