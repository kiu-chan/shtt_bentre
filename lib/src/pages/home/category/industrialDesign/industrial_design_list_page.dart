import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/mainData/data/home/industrialDesign/industrial_design.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:shtt_bentre/src/pages/home/category/industrialDesign/industrial_design_detail_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IndustrialDesignListPage extends StatefulWidget {
  const IndustrialDesignListPage({super.key});

  @override
  State<IndustrialDesignListPage> createState() => _IndustrialDesignListPageState();
}

class _IndustrialDesignListPageState extends State<IndustrialDesignListPage> {
  final Database _service = Database();
  late Future<List<IndustrialDesignModel>> _designsFuture;

  @override
  void initState() {
    super.initState();
    _designsFuture = _service.fetchIndustrialDesigns();
  }

  Future<void> _refreshDesigns() async {
    setState(() {
      _designsFuture = _service.fetchIndustrialDesigns();
    });
  }

  void _onItemTap(IndustrialDesignModel design) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IndustrialDesignDetailPage(id: design.id.toString()),
      ),
    );
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
          l10n.industrialDesign,
          style: const TextStyle(
            color: Color(0xFF1E88E5),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDesigns,
        child: FutureBuilder<List<IndustrialDesignModel>>(
          future: _designsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              print(snapshot.error);
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
                      '${l10n.error}: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshDesigns,
                      child: Text(l10n.tryAgain),
                    ),
                  ],
                ),
              );
            }

            final designs = snapshot.data ?? [];
            if (designs.isEmpty) {
              return Center(
                child: Text('${l10n.noDataAvailable} ${l10n.designCard}'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: designs.length,
              itemBuilder: (context, index) {
                final design = designs[index];
                return GestureDetector(
                  onTap: () => _onItemTap(design),
                  child: _IndustrialDesignCard(design: design),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _IndustrialDesignCard extends StatelessWidget {
  final IndustrialDesignModel design;

  const _IndustrialDesignCard({
    required this.design,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'đang chờ xử lý':
        return const Color(0xFFFFA726);
      case 'đã cấp bằng':
        return const Color(0xFF4CAF50);
      case 'hết hạn':
        return const Color(0xFF9E9E9E);
      case 'từ chối':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                    color: const Color(0xFF5C6BC0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF5C6BC0).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    l10n.designCard,
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
            const SizedBox(height: 16),
            Text(
              design.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF263238),
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
                          design.owner,
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
                          design.address,
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
                        DateFormat('dd/MM/yyyy').format(design.publicationDate),
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
                  '${l10n.maNumber}: ${design.filingNumber}',
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
    );
  }
}