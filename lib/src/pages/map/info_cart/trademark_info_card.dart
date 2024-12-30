import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/home/trademark_detail.dart';
import 'package:shtt_bentre/src/mainData/data/trademark.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:shtt_bentre/src/pages/home/category/trademark/trademark_detail.dart';

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

  @override
  void didUpdateWidget(TrademarkInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTrademark.id != widget.selectedTrademark.id) {
      _loadTrademarkDetails();
    }
  }

  void _loadTrademarkDetails() {
    _trademarkDetailFuture = _database.fetchTrademarkDetail(widget.selectedTrademark.id);
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
          'THÔNG TIN NHÃN HIỆU',
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
            _buildInfoRow('Tên nhãn hiệu', trademark.mark),
            const SizedBox(height: 8),
            _buildInfoRow('Chủ sở hữu', trademark.owner),
            const SizedBox(height: 8),
            _buildInfoRow('Số đơn', trademark.filingNumber),
            const SizedBox(height: 8),
            _buildImageSection(trademark),
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

  Widget _buildImageSection(TrademarkDetailModel trademark) {
    if (trademark.imageUrl.isEmpty) {
      return _buildInfoRow('Hình ảnh', 'Không có hình ảnh để hiển thị.');
    }

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
            trademark.imageUrl,
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
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[200],
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
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
              builder: (context) => TrademarkDetailPage(id: widget.selectedTrademark.id),
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