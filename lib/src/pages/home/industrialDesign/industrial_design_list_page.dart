import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IndustrialDesignModel {
  final String id;
  final String industry;
  final String name;
  final String owner;
  final String address;
  final String image;
  final DateTime publishDate;
  final String status;

  IndustrialDesignModel({
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

class IndustrialDesignListPage extends StatelessWidget {
  const IndustrialDesignListPage({super.key});

  List<IndustrialDesignModel> get _designs => [
    IndustrialDesignModel(
      id: '3-1995-03105',
      industry: 'Bao bì',
      name: 'Giấy gói kẹo',
      owner: 'Nguyễn Minh Chiếm',
      address: '117/51A đường 30/4, phường 4, Thành phố Bến Tre, tỉnh Bến Tre',
      image: 'assets/industrial_designs/1.jpg',
      publishDate: DateTime(1995, 4, 25),
      status: 'Hết hạn',
    ),
    IndustrialDesignModel(
      id: '3-2024-00017',
      industry: 'Bao bì',
      name: 'Bao gói',
      owner: 'Công ty trách nhiệm hữu hạn một thành viên sản xuất thương mại dịch vụ xuất nhập khẩu Cảnh Đồng Xanh',
      address: 'Ấp 2 (tờ bản đồ số 1, thửa đất số 1630), xã Giao Long, huyện Châu Thành, tỉnh Bến Tre',
      image: 'assets/industrial_designs/2.jpg',
      publishDate: DateTime(2024, 3, 25),
      status: 'Đang chờ xử lý',
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
          'Kiểu dáng công nghiệp',
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
        itemCount: _designs.length,
        itemBuilder: (context, index) {
          return _IndustrialDesignCard(design: _designs[index]);
        },
      ),
    );
  }
}

class _IndustrialDesignCard extends StatelessWidget {
  final IndustrialDesignModel design;

  const _IndustrialDesignCard({
    required this.design,
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
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Image section
            SizedBox(
              width: 140,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Image.asset(
                  design.image,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
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
            ),
            // Content section
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Color(0xFFFAFAFA)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Industry and Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            design.industry,
                            style: const TextStyle(
                              color: Color(0xFF3949AB),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(design.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getStatusColor(design.status).withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            design.status,
                            style: TextStyle(
                              color: _getStatusColor(design.status),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Design name
                    Text(
                      design.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF263238),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Owner
                    Text(
                      design.owner,
                      style: const TextStyle(
                        color: Color(0xFF455A64),
                        fontSize: 14,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Date
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E88E5).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: const Color(0xFF1E88E5).withOpacity(0.8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd/MM/yyyy').format(design.publishDate),
                            style: const TextStyle(
                              color: Color(0xFF1565C0),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'đang chờ xử lý':
        return const Color(0xFFFFA726); // Orange
      case 'đã cấp bằng':
        return const Color(0xFF4CAF50); // Green
      case 'hết hạn':
        return const Color(0xFF9E9E9E); // Grey
      case 'từ chối':
        return const Color(0xFFF44336); // Red
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }
}