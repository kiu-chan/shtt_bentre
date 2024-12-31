// lib/src/pages/home/category/initiative/initiative_list_page.dart
import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/home/initiative/initiative.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:shtt_bentre/src/pages/home/category/initiative/initiative_detail_page.dart';

class InitiativeListPage extends StatefulWidget {
  const InitiativeListPage({super.key});

  @override
  State<InitiativeListPage> createState() => _InitiativeListPageState();
}

class _InitiativeListPageState extends State<InitiativeListPage> {
  final Database _initiativeService = Database();
  late Future<List<InitiativeModel>> _initiativesFuture;
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;

  @override
  void initState() {
    super.initState();
    _initiativesFuture = _initiativeService.fetchInitiatives();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= 400) {
      if (!_showBackToTopButton) {
        setState(() {
          _showBackToTopButton = true;
        });
      }
    } else {
      if (_showBackToTopButton) {
        setState(() {
          _showBackToTopButton = false;
        });
      }
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _onInitiativeTap(InitiativeModel initiative) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InitiativeDetailPage(id: initiative.id),
      ),
    );
  }

  Future<void> _refreshInitiatives() async {
    setState(() {
      _initiativesFuture = _initiativeService.fetchInitiatives();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Sáng kiến',
          style: TextStyle(
            color: Color(0xFF1E88E5),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshInitiatives,
        child: FutureBuilder<List<InitiativeModel>>(
          future: _initiativesFuture,
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
                      onPressed: _refreshInitiatives,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            final initiatives = snapshot.data ?? [];
            if (initiatives.isEmpty) {
              return const Center(
                child: Text('Không có dữ liệu sáng kiến'),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: initiatives.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onInitiativeTap(initiatives[index]),
                  child: _InitiativeCard(initiative: initiatives[index]),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: _showBackToTopButton
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: const Color(0xFF1E88E5),
              child: const Icon(Icons.arrow_upward),
            )
          : null,
    );
  }
}

class _InitiativeCard extends StatelessWidget {
  final InitiativeModel initiative;

  const _InitiativeCard({
    required this.initiative,
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
                    color: const Color(0xFF5C6BC0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF5C6BC0).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    initiative.field,
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
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF4CAF50).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    initiative.status,
                    style: const TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              initiative.name,
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
                        Icons.edit,
                        size: 20,
                        color: const Color(0xFF1E88E5).withOpacity(0.8),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tác giả: ${initiative.author}',
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
                        Icons.person,
                        size: 20,
                        color: const Color(0xFF1E88E5).withOpacity(0.8),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Chủ sở hữu: ${initiative.owner}',
                          style: const TextStyle(
                            color: Color(0xFF455A64),
                            fontSize: 14,
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
                          initiative.address,
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
                    'Năm công nhận: ${initiative.recognitionYear}',
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