// lib/src/pages/home/category/initiative/initiative_detail_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/mainData/config/format.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';

class InitiativeDetailPage extends StatefulWidget {
  final String id;

  const InitiativeDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<InitiativeDetailPage> createState() => _InitiativeDetailPageState();
}

class _InitiativeDetailPageState extends State<InitiativeDetailPage> {
  final Database _initiativeService = Database();
  late Future<Map<String, dynamic>> _initiativeFuture;

  @override
  void initState() {
    super.initState();
    _initiativeFuture = _initiativeService.fetchInitiativeDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Chi tiết sáng kiến',
          style: TextStyle(
            color: Color(0xFF1E88E5),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _initiativeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Có lỗi xảy ra: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _initiativeFuture = _initiativeService.fetchInitiativeDetail(widget.id);
                      });
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final initiative = snapshot.data!;
          return _buildContent(initiative);
        },
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> initiative) {
    final dateFormat = DateFormat(Format.dateFormat);
    final createdAt = DateTime.parse(initiative['created_at']);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trạng thái và lĩnh vực
                  Row(
                    children: [
                      _buildStatusBadge(
                        initiative['status'] == '3' ? 'Được phê duyệt' : 'Chờ phê duyệt',
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildFieldBadge(initiative['fields'] ?? ''),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Tên sáng kiến
                  Text(
                    initiative['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263238),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Thông tin chi tiết
          Card(
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    Icons.edit,
                    'Tác giả',
                    initiative['author'] ?? '',
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    Icons.person,
                    'Chủ sở hữu',
                    initiative['owner'] ?? '',
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    Icons.location_on,
                    'Địa chỉ',
                    initiative['address'] ?? '',
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Ngày tạo',
                    dateFormat.format(createdAt),
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    Icons.schedule,
                    'Năm công nhận',
                    initiative['recognition_year']?.toString() ?? '',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Thông tin bổ sung nếu có
          if (initiative['description'] != null && initiative['description'].toString().isNotEmpty)
            Card(
              elevation: 2,
              shadowColor: Colors.black.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mô tả',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E88E5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      initiative['description'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF455A64),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Color(0xFF2E7D32),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFieldBadge(String field) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF5C6BC0).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF5C6BC0).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        field,
        style: const TextStyle(
          color: Color(0xFF3949AB),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E88E5).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF1E88E5),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF263238),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}