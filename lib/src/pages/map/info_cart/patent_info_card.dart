import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/map/patent.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:shtt_bentre/src/pages/home/category/patent/patent_detail_page.dart';
import 'package:shtt_bentre/src/pages/map/info_cart/info_card_base.dart';

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
  final Database _patentsDatabase = Database();
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
    _patentDetailsFuture = _patentsDatabase.fetchPatentDetail(
      widget.selectedPatent.id.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InfoCardBase(
      title: 'SÁNG CHẾ',
      isRightMenuOpen: widget.isRightMenuOpen,
      onMapTap: widget.onMapTap,
      content: _buildContent(),
    );
  }

  Widget _buildContent() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _patentDetailsFuture,
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
                  onPressed: _loadPatentDetails,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        final patentDetails = snapshot.data!;
        final images = patentDetails['images'] as List?;
        final imageUrl = images?.isNotEmpty == true ? images![0]['file_url'] as String? : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InfoCardRow(
              label: 'Tên sáng chế',
              value: patentDetails['title'] ?? 'Không có thông tin',
              useColumn: true,
            ),
            const SizedBox(height: 8),
            InfoCardRow(
              label: 'Người nộp đơn',
              value: patentDetails['applicant'] ?? 'Không có thông tin',
              useColumn: true,
            ),
            const SizedBox(height: 8),
            InfoCardRow(
              label: 'Số đơn',
              value: patentDetails['filing_number'] ?? 'Không có thông tin',
              useColumn: true,
            ),
            const SizedBox(height: 8),
            InfoCardImageSection(imageUrl: imageUrl),
            const SizedBox(height: 16),
            InfoCardDetailButton(
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
            ),
          ],
        );
      },
    );
  }
}