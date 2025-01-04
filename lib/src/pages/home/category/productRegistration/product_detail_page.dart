import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';

class ProductDetailPage extends StatefulWidget {
  final String id;

  const ProductDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<Map<String, dynamic>> _productFuture;
  final Database _service = Database();

  @override
  void initState() {
    super.initState();
    _productFuture = fetchProductDetail();
  }

  Future<Map<String, dynamic>> fetchProductDetail() async {
    return _service.fetchProductDetail(widget.id);
  }

  String _formatDateTime(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd.MM.yyyy HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Chi tiết sản phẩm',
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
        future: _productFuture,
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
                        _productFuture = fetchProductDetail();
                      });
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E88E5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Main Info Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          Icons.business,
                          'Chủ nhãn hiệu',
                          product['owner'] ?? '',
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          Icons.location_on,
                          'Địa chỉ',
                          product['address'] ?? '',
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          Icons.contact_phone,
                          'Liên hệ',
                          product['contact'] ?? '',
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          Icons.person,
                          'Đại diện pháp luật',
                          product['representatives'] ?? '',
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          Icons.calendar_today,
                          'Ngày đăng ký',
                          _formatDateTime(product['created_at']),
                        ),
                        if (product['updated_at'] != null) ...[
                          const Divider(height: 24),
                          _buildInfoRow(
                            Icons.update,
                            'Cập nhật lúc',
                            _formatDateTime(product['updated_at']),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Additional Info Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thông tin bổ sung',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E88E5),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSection('Ghi chú', product['note']),
                        const SizedBox(height: 16),
                        _buildSection('Tài liệu kèm', product['attachments']),
                        const SizedBox(height: 16),
                        _buildSection('Hình ảnh', product['images']),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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

  Widget _buildSection(String title, dynamic content) {
    String displayContent = 'Không có thông tin';
    
    if (content != null) {
      if (content is List && content.isNotEmpty) {
        displayContent = content.join(', ');
      } else if (content is String && content.isNotEmpty) {
        displayContent = content;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF455A64),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          displayContent,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF546E7A),
          ),
        ),
      ],
    );
  }
}