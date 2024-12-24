// research_project_detail_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/mainData/data/home/research_project.dart';
import 'package:shtt_bentre/src/mainData/database/home/research_project.dart';

class ResearchProjectDetailPage extends StatefulWidget {
  final String id;

  const ResearchProjectDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _ResearchProjectDetailPageState createState() => _ResearchProjectDetailPageState();
}

class _ResearchProjectDetailPageState extends State<ResearchProjectDetailPage> {
  late Future<ResearchProjectModel> _projectFuture;
  final ResearchProjectService _service = ResearchProjectService();

  @override
  void initState() {
    super.initState();
    _projectFuture = _service.fetchResearchProjectDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết dự án'),
      ),
      body: FutureBuilder<ResearchProjectModel>(
        future: _projectFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          final project = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.projectName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Chủ nhiệm dự án:', project.researcher),
                _buildInfoRow('Tổ chức/cơ sở nghiên cứu:', project.organization),
                _buildInfoRow('Ngày bắt đầu:', DateFormat('dd/MM/yyyy').format(project.startDate)),
                _buildInfoRow('Công tác/viên đồi tác:', ''),
                _buildInfoRow('Nguồn tài trợ:', ''),
                _buildInfoRow('Ngành/chuyên ngành dự án:', ''),
                _buildInfoRow('Mục tiêu dự án:', ''),
                _buildInfoRow('Tác động và ứng dụng thực tiễn:', ''),
                _buildInfoRow('Trạng thái:', project.status),
                _buildInfoRow('Nội dung:', ''),
                _buildInfoRow('Các ấn phẩm khoa học liên quan:', ''),
                _buildInfoRow('Bằng sáng chế liên quan:', ''),
                _buildInfoRow('Cấc tài liệu đối chứng:', ''),
                _buildInfoRow('Không có tài liệu:', ''),
                _buildInfoRow('Hình ảnh:', ''),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}