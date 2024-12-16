import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/pages/home/patent_detail_page.dart';
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
    // Thêm dữ liệu mẫu khác ở đây
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Sáng chế toàn văn',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _patents.length,
        itemBuilder: (context, index) {
          return PatentCard(patent: _patents[index]);
        },
      ),
    );
  }
}

class PatentCard extends StatelessWidget {
  final PatentModel patent;

  const PatentCard({
    super.key,
    required this.patent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatentDetailPage(patent: patent),
            ),
          );
        },
        child: Padding(
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
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      patent.field,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Mã đơn: ${patent.id}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                patent.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.business,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      patent.owner,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('dd/MM/yyyy').format(patent.date),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      patent.status,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}