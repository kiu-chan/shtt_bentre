import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrademarkModel {
  final String id;
  final String industry;
  final String name;
  final String owner;
  final String address;
  final String image;
  final DateTime publishDate;
  final String status;

  TrademarkModel({
    required this.id,
    required this.industry,
    required this.name,
    required this.owner,
    required this.address,
    required this.image,
    required this.publishDate,
    required this.status,
  });
}

class TrademarkListPage extends StatelessWidget {
  const TrademarkListPage({super.key});

  List<TrademarkModel> get _trademarks => [
    TrademarkModel(
      id: 'TM-001',
      industry: 'Thực phẩm & Đồ uống',
      name: 'COCOXIM',
      owner: 'Công ty TNHH Chế biến dừa Lương Quới',
      address: 'Ấp Quới Thạnh, Xã Quới Thạnh, Huyện Châu Thành, Tỉnh Bến Tre',
      image: 'assets/trademark/cocoxim.jpg',
      publishDate: DateTime(2024, 1, 15),
      status: 'Đã đăng ký',
    ),
    TrademarkModel(
      id: 'TM-002',
      industry: 'Nông sản',
      name: 'BẾN TRE XANH',
      owner: 'Công ty TNHH Nông sản Bến Tre',
      address: 'Số 123, Đường 30/4, Phường 4, TP Bến Tre, Tỉnh Bến Tre',
      image: 'assets/trademark/bentrexanh.jpg',
      publishDate: DateTime(2024, 2, 20),
      status: 'Đang xử lý',
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
          'Bảo hộ nhãn hiệu',
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
        itemCount: _trademarks.length,
        itemBuilder: (context, index) {
          return _TrademarkCard(trademark: _trademarks[index]);
        },
      ),
    );
  }
}

class _TrademarkCard extends StatelessWidget {
  final TrademarkModel trademark;

  const _TrademarkCard({
    required this.trademark,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              trademark.image,
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
          // Content section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Color(0xFFFAFAFA)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Industry and Status row
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
                        trademark.industry,
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
                        color: trademark.status == 'Đã đăng ký' 
                          ? const Color(0xFF4CAF50).withOpacity(0.1)
                          : const Color(0xFFFFA726).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: trademark.status == 'Đã đăng ký'
                            ? const Color(0xFF4CAF50).withOpacity(0.2)
                            : const Color(0xFFFFA726).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        trademark.status,
                        style: TextStyle(
                          color: trademark.status == 'Đã đăng ký'
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFE65100),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Trademark name
                Text(
                  trademark.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF263238),
                  ),
                ),
                const SizedBox(height: 12),
                // Owner info
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
                              trademark.owner,
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
                            Icons.location_on,
                            size: 20,
                            color: const Color(0xFF1E88E5).withOpacity(0.8),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              trademark.address,
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
                // Publish date
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
                            'Ngày công bố: ${DateFormat('dd/MM/yyyy').format(trademark.publishDate)}',
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
                      'Mã số: ${trademark.id}',
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
    );
  }
}