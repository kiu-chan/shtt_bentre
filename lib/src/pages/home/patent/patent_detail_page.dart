import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/pages/models/patent_model.dart';

class PatentDetailPage extends StatelessWidget {
  final PatentModel patent;

  const PatentDetailPage({
    super.key,
    required this.patent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sáng chế'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (patent.image.isNotEmpty)
              Image.asset(
                patent.image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection('Mã đơn:', patent.id),
                  const SizedBox(height: 16),
                  _buildInfoSection('Tên sáng chế:', patent.title),
                  const SizedBox(height: 16),
                  _buildInfoSection('Lĩnh vực:', patent.field),
                  const SizedBox(height: 16),
                  _buildInfoSection('Chủ đơn:', patent.owner),
                  const SizedBox(height: 8),
                  _buildInfoSection('Địa chỉ:', patent.address),
                  const SizedBox(height: 16),
                  _buildInfoSection('Ngày nộp đơn:', 
                    DateFormat('dd/MM/yyyy').format(patent.date)),
                  const SizedBox(height: 16),
                  _buildInfoSection('Trạng thái:', patent.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String label, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}