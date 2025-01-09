import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/mainData/data/home/warning.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';

class WarningDetailPage extends StatefulWidget {
  final int id;

  const WarningDetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<WarningDetailPage> createState() => _WarningDetailPageState();
}

class _WarningDetailPageState extends State<WarningDetailPage> {
  late Future<WarningModel> _warningFuture;
  Database db = Database();

  @override
  void initState() {
    super.initState();
    _warningFuture = db.fetchWarningDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Chi tiết cảnh báo',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<WarningModel>(
        future: _warningFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Không thể tải thông tin',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Đã xảy ra lỗi khi tải chi tiết cảnh báo. Vui lòng thử lại sau.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _warningFuture = db.fetchWarningDetail(widget.id);
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tải lại'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final warning = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildChip(
                      label: _getTypeText(warning.type),
                      color: _getTypeColor(warning.type),
                      icon: _getTypeIcon(warning.type),
                    ),
                    const Spacer(),
                    _buildChip(
                      label: _getStatusText(warning.status),
                      color: _getStatusColor(warning.status),
                      icon: _getStatusIcon(warning.status),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Text(
                  warning.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                ),
                const SizedBox(height: 20),

                if (warning.description != null &&
                    warning.description!.isNotEmpty) ...[
                  const Divider(height: 1),
                  const SizedBox(height: 20),
                  Text(
                    'Mô tả chi tiết',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    warning.description!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                          color: Colors.black87,
                        ),
                  ),
                  const SizedBox(height: 20),
                ],

                if (warning.assetType != null &&
                    warning.assetType!.isNotEmpty) ...[
                  const Divider(height: 1),
                  const SizedBox(height: 20),
                  _buildInfoSection(
                    context: context,
                    icon: Icons.category_rounded,
                    title: 'Loại tài sản',
                    content: warning.assetType!,
                  ),
                  const SizedBox(height: 20),
                ],

                const Divider(height: 1),
                const SizedBox(height: 20),
                _buildInfoSection(
                  context: context,
                  icon: Icons.update_rounded,
                  title: 'Cập nhật lần cuối',
                  content:
                      DateFormat('HH:mm - dd/MM/yyyy').format(warning.updatedAt),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black87,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getTypeText(String type) {
    switch (type.toLowerCase()) {
      case 'alert':
        return 'CẢNH BÁO';
      case 'report':
        return 'BÁO CÁO';
      default:
        return type.toUpperCase();
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'alert':
        return Icons.warning_rounded;
      case 'report':
        return Icons.assignment_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'ĐANG CHỜ';
      case 'completed':
        return 'HOÀN THÀNH';
      case 'rejected':
        return 'TỪ CHỐI';
      default:
        return status.toUpperCase();
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty_rounded;
      case 'completed':
        return Icons.check_circle_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      default:
        return Icons.help_rounded;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'alert':
        return Colors.red;
      case 'report':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}