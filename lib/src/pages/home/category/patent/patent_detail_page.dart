import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shtt_bentre/src/mainData/database/home/patents.dart';

class PatentDetailPage extends StatefulWidget {
  final String id;

  const PatentDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<PatentDetailPage> createState() => _PatentDetailPageState();
}

class _PatentDetailPageState extends State<PatentDetailPage> {
  final PatentsDatabase _database = PatentsDatabase();
  late Future<Map<String, dynamic>> _patentFuture;

  @override
  void initState() {
    super.initState();
    _patentFuture = _database.fetchPatentDetail(widget.id);
  }

  String _formatAbstract(String? abstract) {
    if (abstract == null) return '';
    
    return abstract
        .replaceAll('&aacute;', 'á')
        .replaceAll('&agrave;', 'à')
        .replaceAll('&atilde;', 'ã')
        .replaceAll('&eacute;', 'é')
        .replaceAll('&egrave;', 'è')
        .replaceAll('&etilde;', 'ẽ')
        .replaceAll('&iacute;', 'í')
        .replaceAll('&igrave;', 'ì')
        .replaceAll('&itilde;', 'ĩ')
        .replaceAll('&oacute;', 'ó')
        .replaceAll('&ograve;', 'ò')
        .replaceAll('&otilde;', 'õ')
        .replaceAll('&uacute;', 'ú')
        .replaceAll('&ugrave;', 'ù')
        .replaceAll('&utilde;', 'ũ')
        .replaceAll('&yacute;', 'ý')
        .replaceAll('&ygrave;', 'ỳ')
        .replaceAll('\\u0026', '&')
        .replaceAll('\\u003E', '>')
        .replaceAll('\\u003C', '<');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sáng chế'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _patentFuture,
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
                        _patentFuture = _database.fetchPatentDetail(widget.id);
                      });
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final patent = snapshot.data!;
          String formattedAbstract = _formatAbstract(patent['abstract']);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (patent['images'] != null && (patent['images'] as List).isNotEmpty)
                  Image.network(
                    patent['images'][0]['file_url'],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey.withOpacity(0.1),
                        child: Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      );
                    },
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection('Số đơn:', patent['filing_number'] ?? ''),
                      const SizedBox(height: 16),
                      _buildInfoSection('Loại đơn:', patent['application_type'] ?? ''),
                      const SizedBox(height: 16),
                      _buildInfoSection('Tên sáng chế:', patent['title'] ?? ''),
                      const SizedBox(height: 16),
                      _buildInfoSection('Lĩnh vực:', patent['type'] ?? ''),
                      const SizedBox(height: 16),
                      _buildInfoSection('Phân loại IPC:', patent['ipc_classes'] ?? ''),
                      const SizedBox(height: 16),
                      _buildInfoSection('Chủ đơn:', patent['applicant'] ?? ''),
                      const SizedBox(height: 8),
                      _buildInfoSection('Địa chỉ chủ đơn:', patent['applicant_address'] ?? ''),
                      const SizedBox(height: 16),
                      _buildInfoSection('Tác giả:', patent['inventor'] ?? ''),
                      const SizedBox(height: 8),
                      _buildInfoSection('Địa chỉ tác giả:', patent['inventor_address'] ?? ''),
                      if (patent['other_inventor'] != null && patent['other_inventor'].toString().isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildInfoSection('Đồng tác giả:', patent['other_inventor']),
                      ],
                      const SizedBox(height: 16),
                      _buildInfoSection('Ngày nộp đơn:', patent['filing_date'] ?? ''),
                      const SizedBox(height: 8),
                      _buildInfoSection('Số công bố:', patent['publication_number'] ?? ''),
                      const SizedBox(height: 8),
                      _buildInfoSection('Ngày công bố:', patent['publication_date'] ?? ''),
                      const SizedBox(height: 16),
                      _buildInfoSection('Trạng thái:', patent['status'] ?? ''),
                      if (formattedAbstract.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Tóm tắt:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Html(
                          data: formattedAbstract,
                          style: {
                            "body": Style(
                              fontSize: FontSize(16),
                              lineHeight: const LineHeight(1.5),
                            ),
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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