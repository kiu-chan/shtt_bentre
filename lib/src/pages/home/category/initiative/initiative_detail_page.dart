import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/mainData/config/format.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final Database _service = Database();
  late Future<Map<String, dynamic>> _initiativeFuture;

  @override
  void initState() {
    super.initState();
    _initiativeFuture = _service.fetchInitiativeDetail(widget.id);
  }

  String _formatDate(DateTime date) {
    return DateFormat(Format.dateFormat).format(date);
  }

  Color _getStatusColor(String status) {
    if (status == '3') {
      return const Color(0xFF4CAF50); // Được phê duyệt
    }
    return const Color(0xFFFFA726); // Chờ phê duyệt
  }

  String _getStatusText(String status) {
    if (status == '3') {
      return 'Được phê duyệt';
    }
    return 'Chờ phê duyệt';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Chi tiết sáng kiến',
          style: const TextStyle(
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
                        _initiativeFuture = _service.fetchInitiativeDetail(widget.id);
                      });
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final initiative = snapshot.data!;
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
                  child: Container(
                    padding: const EdgeInsets.all(20),
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
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF5C6BC0).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF5C6BC0).withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                initiative['fields'] ?? '',
                                style: const TextStyle(
                                  color: Color(0xFF3949AB),
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
                                color: _getStatusColor(initiative['status']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getStatusColor(initiative['status']).withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _getStatusText(initiative['status']),
                                style: TextStyle(
                                  color: _getStatusColor(initiative['status']),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          initiative['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF263238),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildInfoSection(
                          'Thông tin chung',
                          Icons.info_outline,
                          [
                            _buildInfoRow(
                              Icons.edit,
                              'Tác giả',
                              initiative['author'] ?? '',
                            ),
                            _buildInfoRow(
                              Icons.person,
                              'Chủ sở hữu',
                              initiative['owner'] ?? '',
                            ),
                            _buildInfoRow(
                              Icons.location_on,
                              'Địa chỉ',
                              initiative['address'] ?? '',
                            ),
                            _buildInfoRow(
                              Icons.calendar_today,
                              'Ngày tạo',
                              _formatDate(createdAt),
                            ),
                            _buildInfoRow(
                              Icons.schedule,
                              'Năm công nhận',
                              initiative['recognition_year']?.toString() ?? '',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (initiative['description'] != null && 
                    initiative['description'].toString().isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
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
                          Row(
                            children: [
                              const Icon(
                                Icons.description_outlined,
                                color: Color(0xFF1E88E5),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Mô tả',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E88E5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            initiative['description'],
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF455A64),
                              height: 1.6,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF1E88E5),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E88E5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
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
      ),
    );
  }
}