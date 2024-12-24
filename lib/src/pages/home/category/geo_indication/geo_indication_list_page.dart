import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/mainData/data/home/geoIndication/geo_indication.dart';
import 'package:shtt_bentre/src/mainData/database/home/geo_indication.dart';
import 'package:shtt_bentre/src/pages/home/category/geo_indication/geo_indication_detail_page.dart';

class GeoIndicationListPage extends StatefulWidget {
  const GeoIndicationListPage({super.key});

  @override
  State<GeoIndicationListPage> createState() => _GeoIndicationListPageState();
}

class _GeoIndicationListPageState extends State<GeoIndicationListPage> {
  final GeoIndicationService _service = GeoIndicationService();
  late Future<List<GeoIndicationModel>> _geoIndicationsFuture;

  @override
  void initState() {
    super.initState();
    _geoIndicationsFuture = _service.fetchGeoIndications();
  }

  void _onItemTap(GeoIndicationModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GeoIndicationDetailPage(stt: item.stt),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Chỉ dẫn địa lý',
          style: TextStyle(
            color: Color(0xFF1E88E5),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
      ),
      body: FutureBuilder<List<GeoIndicationModel>>(
        future: _geoIndicationsFuture,
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
                        _geoIndicationsFuture = _service.fetchGeoIndications();
                      });
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final geoIndications = snapshot.data ?? [];
          if (geoIndications.isEmpty) {
            return const Center(
              child: Text('Không có dữ liệu chỉ dẫn địa lý'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: geoIndications.length,
            itemBuilder: (context, index) {
              final item = geoIndications[index];
              return GestureDetector(
                onTap: () => _onItemTap(item),
                child: _GeoIndicationCard(data: item),
              );
            },
          );
        },
      ),
    );
  }
}

class _GeoIndicationCard extends StatelessWidget {
  final GeoIndicationModel data;

  const _GeoIndicationCard({
    required this.data,
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
      child: Container(
        padding: const EdgeInsets.all(16),
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
                      color: Color(0xFF2E7D32),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                if (data.soDon != null)
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
                      'Mã số: ${data.soDon}',
                      style: const TextStyle(
                        color: Color(0xFF1565C0),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              data.tenSanPham,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF263238),
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
                      data.donViQuanLy,
                      style: const TextStyle(
                        color: Color(0xFF455A64),
                        fontSize: 14,
                        height: 1.4,
                      ),
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
                    'Ngày cấp: ${DateFormat('dd/MM/yyyy').format(data.ngayCap)}',
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
    );
  }
}