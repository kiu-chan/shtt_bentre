// technical_competition_detail_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/mainData/data/home/technicalCompetition/technical_competition.dart';

class TechnicalCompetitionDetailPage extends StatelessWidget {
  final TechnicalCompetitionModel competition;

  const TechnicalCompetitionDetailPage({Key? key, required this.competition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          competition.name,  
          style: const TextStyle(
            color: Color(0xFF1E88E5),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection('Đơn vị:', competition.organization),
            _buildInfoSection('Lĩnh vực:', competition.field),
            _buildInfoSection('Ngày nộp hồ sơ:', DateFormat('dd/MM/yyyy').format(DateTime.parse(competition.submissionDate))),
            _buildInfoSection('Năm thi:', competition.year.toString()),  
            _buildInfoSection('Giải:', competition.resultStatus),

            // Hiển thị các thông tin khác nếu có
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF455A64),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}