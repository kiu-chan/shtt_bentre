import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResearchProjectModel {
  final String id;
  final String type;
  final String projectName;
  final String researcher;
  final String organization;
  final DateTime startDate;
  final String image;
  final String status;

  ResearchProjectModel({
    required this.id,
    required this.type,
    required this.projectName,
    required this.researcher,
    required this.organization,
    required this.startDate,
    required this.image,
    required this.status,
  });
}

class ResearchProjectListPage extends StatelessWidget {
  const ResearchProjectListPage({super.key});

  List<ResearchProjectModel> get _projects => [
    ResearchProjectModel(
      id: '1',
      type: 'Nghiên cứu ứng dụng',
      projectName: 'BBBBBBBB',
      researcher: 'BF1',
      organization: 'BG1',
      startDate: DateTime(2023, 2, 6),
      image: '',
      status: 'Đang thực hiện',
    ),
    ResearchProjectModel(
      id: '2',
      type: 'Phát triển sản phẩm',
      projectName: 'AAAAAAAAAAAA',
      researcher: 'AO1',
      organization: 'AC1',
      startDate: DateTime(2024, 9, 18),
      image: 'assets/research/project2.jpg',
      status: 'Đã được cấp bằng',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'NCKH & ĐMST',
          style: TextStyle(
            color: Color(0xFF1E88E5),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _projects.length,
        itemBuilder: (context, index) {
          return _ResearchProjectCard(project: _projects[index]);
        },
      ),
    );
  }
}

class _ResearchProjectCard extends StatelessWidget {
  final ResearchProjectModel project;

  const _ResearchProjectCard({
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFFAFAFA)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project.image.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  project.image,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey.withOpacity(0.1),
                      child: Icon(
                        Icons.image_outlined,
                        size: 48,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C27B0).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF9C27B0).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          project.type,
                          style: const TextStyle(
                            color: Color(0xFF7B1FA2),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(project.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getStatusColor(project.status).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          project.status,
                          style: TextStyle(
                            color: _getStatusColor(project.status),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    project.projectName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF263238),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 20,
                              color: const Color(0xFF1E88E5).withOpacity(0.8),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Nhà nghiên cứu: ${project.researcher}',
                                style: const TextStyle(
                                  color: Color(0xFF455A64),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.business,
                              size: 20,
                              color: const Color(0xFF1E88E5).withOpacity(0.8),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Tổ chức: ${project.organization}',
                                style: const TextStyle(
                                  color: Color(0xFF455A64),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E88E5).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: const Color(0xFF1E88E5).withOpacity(0.8),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ngày bắt đầu: ${DateFormat('dd.MM.yyyy').format(project.startDate)}',
                          style: const TextStyle(
                            color: Color(0xFF1565C0),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'đang thực hiện':
        return const Color(0xFFFFA726); // Orange
      case 'đã được cấp bằng':
        return const Color(0xFF4CAF50); // Green
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }
}