import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/pages/home/category/patent/patent_detail_page.dart';
import 'package:shtt_bentre/src/pages/models/patent_model.dart';

class PatentListPage extends StatelessWidget {
  const PatentListPage({super.key});

  List<PatentModel> get _patents => [
    PatentModel(
      id: '1-2023-07047',
      title: 'Quy trình sản xuất các chế phẩm chăm sóc cá nhân, tẩy rửa gia dụng, chăm sóc thú cưng có sử dụng dịch nước cất từ mật hoa dừa',
      field: 'Hóa học',
      image: 'assets/patent_images/1.jpg',
      owner: 'Công ty Cổ phần Phát triển thực mỹ phẩm VFarm',
      status: 'Chờ xử lý',
      address: 'Số 4-5, lô 7, chung cư Giao Long, ấp Quới Thạnh Đông, xã Quới Sơn, huyện Châu Thành, tỉnh Bến Tre',
      date: DateTime(2024, 2, 26),
    ),
    // Add more sample data here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Sáng chế toàn văn',
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
        itemCount: _patents.length,
        itemBuilder: (context, index) {
          return _PatentCard(patent: _patents[index]);
        },
      ),
    );
  }
}

class _PatentCard extends StatelessWidget {
  final PatentModel patent;

  const _PatentCard({
    required this.patent,
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
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatentDetailPage(patent: patent),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
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
              if (patent.image.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    patent.image,
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
                            color: const Color(0xFF1E88E5).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF1E88E5).withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            patent.field,
                            style: const TextStyle(
                              color: Color(0xFF1565C0),
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
                            color: _getStatusColor(patent.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getStatusColor(patent.status).withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            patent.status,
                            style: TextStyle(
                              color: _getStatusColor(patent.status),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      patent.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF263238),
                        height: 1.5,
                      ),
                      maxLines: 3,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                  patent.owner,
                                  style: const TextStyle(
                                    color: Color(0xFF455A64),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 20,
                                color: const Color(0xFF1E88E5).withOpacity(0.8),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  patent.address,
                                  style: const TextStyle(
                                    color: Color(0xFF455A64),
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: const Color(0xFF1E88E5).withOpacity(0.8),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('dd/MM/yyyy').format(patent.date),
                                style: const TextStyle(
                                  color: Color(0xFF1565C0),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Mã đơn: ${patent.id}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'chờ xử lý':
        return const Color(0xFFFFA726); // Orange
      case 'đã cấp bằng':
        return const Color(0xFF4CAF50); // Green
      case 'từ chối':
        return const Color(0xFFF44336); // Red
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }
}