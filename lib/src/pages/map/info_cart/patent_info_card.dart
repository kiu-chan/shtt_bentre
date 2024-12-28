import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/patent.dart';
import 'package:shtt_bentre/src/mainData/database/home/patents.dart';
import 'package:shtt_bentre/src/pages/home/category/patent/patent_detail_page.dart';

class PatentInfoCard extends StatefulWidget {
  final Patent selectedPatent;
  final Function(dynamic, dynamic) onMapTap;
  final bool isRightMenuOpen;

  const PatentInfoCard({
    super.key,
    required this.selectedPatent,
    required this.onMapTap,
    required this.isRightMenuOpen,
  });

  @override
  State<PatentInfoCard> createState() => _PatentInfoCardState();
}

class _PatentInfoCardState extends State<PatentInfoCard> {
  final PatentsDatabase _patentsDatabase = PatentsDatabase();
  late Future<Map<String, dynamic>> _patentDetailsFuture;

  @override
  void initState() {
    super.initState();
    _loadPatentDetails();
  }

  @override
  void didUpdateWidget(PatentInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedPatent.id != widget.selectedPatent.id) {
      _loadPatentDetails();
    }
  }

  void _loadPatentDetails() {
    _patentDetailsFuture = _patentsDatabase.fetchPatentDetail(widget.selectedPatent.id.toString());
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
          'THÔNG TIN SÁNG CHẾ',
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
    return FutureBuilder<Map<String, dynamic>>(
      future: _patentDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
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
                  onPressed: _loadPatentDetails,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        final patentDetails = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoRow('Tên sáng chế', patentDetails['title'] ?? 'Không có thông tin'),
            const SizedBox(height: 8),
            _buildInfoRow('Người nộp đơn', patentDetails['applicant'] ?? 'Không có thông tin'),
            const SizedBox(height: 8),
            _buildInfoRow('Số đơn', patentDetails['filing_number'] ?? 'Không có thông tin'),
            const SizedBox(height: 8),
            _buildImageSection(patentDetails),
            const SizedBox(height: 16),
            _buildViewDetailsButton(patentDetails),
          ],
        );
      },
    );
  }

  Widget _buildImageSection(Map<String, dynamic> patentDetails) {
    final images = patentDetails['images'] as List?;
    if (images == null || images.isEmpty) {
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
            images[0]['file_url'],
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildViewDetailsButton(Map<String, dynamic> patentDetails) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatentDetailPage(
                id: widget.selectedPatent.id.toString(),
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