import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/home/initiative/initiative.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:shtt_bentre/src/pages/home/category/initiative/initiative_card.dart';
import 'package:shtt_bentre/src/pages/home/category/initiative/initiative_detail_page.dart';
import 'package:shtt_bentre/src/pages/home/category/initiative/initiative_filter_menu.dart';

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
  String? _selectedYear;
  List<String> _availableYears = [];
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    _initiativesFuture = _initiativeService.fetchInitiatives();
    _scrollController.addListener(_scrollListener);
    _loadFilterData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadFilterData() async {
    try {
      final years = await _initiativeService.initiative.fetchAvailableYears();
      setState(() {
        _availableYears = years;
      });
    } catch (e) {
      print('Error loading filter data: $e');
    }
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InitiativeFilterMenu(
          selectedYear: _selectedYear,
          availableYears: _availableYears,
          onYearChanged: (value) => setState(() => _selectedYear = value),
          onApply: () {
            Navigator.pop(context);
            _applyFilters();
          },
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  void _applyFilters() {
    setState(() {
      _initiativesFuture = _initiativeService.initiative.fetchInitiatives(
        year: _selectedYear
      );
      _isFiltered = _selectedYear != null;
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedYear = null;
      _isFiltered = false;
      _initiativesFuture = _initiativeService.fetchInitiatives();
    });
  }

  Widget _buildActiveFilters() {
    if (!_isFiltered) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text(
            'Đang lọc:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E88E5),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              spacing: 8,
              children: [
                if (_selectedYear != null)
                  Chip(
                    label: Text('Năm $_selectedYear'),
                    onDeleted: () {
                      setState(() {
                        _selectedYear = null;
                        _applyFilters();
                      });
                    },
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: _resetFilters,
            child: const Text('Xóa lọc'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshInitiatives() async {
    setState(() {
      _selectedYear = null;
      _isFiltered = false;
      _initiativesFuture = _initiativeService.fetchInitiatives();
    });
    await _loadFilterData();
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
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterDialog,
              ),
              if (_isFiltered)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 8,
                      minHeight: 8,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildActiveFilters(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshInitiatives,
              child: FutureBuilder<List<InitiativeModel>>(
                future: _initiativesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    print('Có lỗi xảy ra: ${snapshot.error}');
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
                  if (initiatives.isEmpty && _isFiltered) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Không tìm thấy sáng kiến phù hợp',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

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
                        child: InitiativeCard(initiative: initiatives[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
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