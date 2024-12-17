import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GeoIndicationModel {
  final String id;
  final String productName;
  final String managementUnit;
  final DateTime grantDate;

  GeoIndicationModel({
    required this.id,
    required this.productName,
    required this.managementUnit,
    required this.grantDate,
  });
}

class GeoIndicationListPage extends StatelessWidget {
  const GeoIndicationListPage({super.key});

  List<GeoIndicationModel> get _geoIndications => [
    GeoIndicationModel(
      id: '6-2017-00007',
      productName: 'Dừa uống nước Xiêm Xanh',
      managementUnit: 'Sở Khoa học và Công nghệ Bến Tre',
      grantDate: DateTime(2018, 1, 26),
    ),
    GeoIndicationModel(
      id: '6-2019-00010',
      productName: 'Sầu riêng Cái Mơn',
      managementUnit: 'Sở Khoa học và Công nghệ tỉnh Bến Tre',
      grantDate: DateTime(2020, 5, 11),
    ),
    GeoIndicationModel(
      id: '6-2020-00015',
      productName: 'Tôm càng xanh',
      managementUnit: 'Sở Khoa học và Công nghệ tỉnh Bến Tre',
      grantDate: DateTime(2021, 4, 19),
    ),
    GeoIndicationModel(
      id: '6-2007-00003',
      productName: 'Xoài tứ quý',
      managementUnit: 'Sở Khoa học và Công nghệ tỉnh Bến Tre',
      grantDate: DateTime(2022, 11, 10),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light grayish background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Chỉ dẫn địa lý',
          style: TextStyle(
            color: Color(0xFF1E88E5), // Deep blue
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _geoIndications.length,
        itemBuilder: (context, index) {
          return _GeoIndicationCard(geoIndication: _geoIndications[index]);
        },
      ),
    );
  }
}

class _GeoIndicationCard extends StatelessWidget {
  final GeoIndicationModel geoIndication;

  const _GeoIndicationCard({
    required this.geoIndication,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
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
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF4CAF50).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      'Chỉ dẫn địa lý',
                      style: TextStyle(
                        color: Color(0xFF2E7D32), // Deep green
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E88E5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Mã số: ${geoIndication.id}',
                      style: const TextStyle(
                        color: Color(0xFF1565C0), // Darker blue
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                geoIndication.productName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF263238), // Very dark blue-grey
                  height: 1.3,
                ),
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
                child: Row(
                  children: [
                    Icon(
                      Icons.business,
                      size: 20,
                      color: const Color(0xFF1E88E5).withOpacity(0.8),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        geoIndication.managementUnit,
                        style: const TextStyle(
                          color: Color(0xFF455A64), // Blue-grey
                          fontSize: 14,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                      'Ngày cấp: ${DateFormat('dd/MM/yyyy').format(geoIndication.grantDate)}',
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
      ),
    );
  }
}