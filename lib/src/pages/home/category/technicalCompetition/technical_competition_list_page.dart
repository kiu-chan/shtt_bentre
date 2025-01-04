import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/home/technicalCompetition/technical_competition.dart';
import 'package:shtt_bentre/src/mainData/database/home/technical_competition.dart';
import 'package:shtt_bentre/src/pages/home/category/technicalCompetition/technical_competition_card.dart';
import 'package:shtt_bentre/src/pages/home/category/technicalCompetition/technical_competition_filter_menu.dart';

class TechnicalCompetitionListPage extends StatefulWidget {
  const TechnicalCompetitionListPage({super.key});

  @override
  State<TechnicalCompetitionListPage> createState() => _TechnicalCompetitionListPageState();
}

class _TechnicalCompetitionListPageState extends State<TechnicalCompetitionListPage> {
  final TechnicalCompetitionService _service = TechnicalCompetitionService();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  
  late Future<List<TechnicalCompetitionModel>> _competitionsFuture;
  List<Map<String, dynamic>> _availableYears = [];
  List<Map<String, dynamic>> _availableFields = [];
  List<Map<String, dynamic>> _availableRanks = [];
  
  String? _selectedYear;
  String? _selectedField;
  String? _selectedRank;
  bool _isFiltered = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _competitionsFuture = _service.fetchCompetitions();
    _loadFilterData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadFilterData() async {
    try {
      final years = await _service.fetchCompetitionsByYear();
      final fields = await _service.fetchCompetitionsByField();
      final ranks = await _service.fetchCompetitionsByRank();
      
      setState(() {
        _availableYears = years;
        _availableFields = fields;
        _availableRanks = ranks;
      });
    } catch (e) {
      print('Error loading filter data: $e');
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _isSearching = _searchController.text.isNotEmpty;
        _competitionsFuture = _service.fetchCompetitions(
          search: _searchController.text,
          year: _selectedYear,
          field: _selectedField,
          rank: _selectedRank,
        );
      });
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TechnicalCompetitionFilterMenu(
          selectedYear: _selectedYear,
          selectedField: _selectedField,
          selectedRank: _selectedRank,
          availableYears: _availableYears,
          availableFields: _availableFields,
          availableRanks: _availableRanks,
          onYearChanged: (value) => setState(() => _selectedYear = value),
          onFieldChanged: (value) => setState(() => _selectedField = value),
          onRankChanged: (value) => setState(() => _selectedRank = value),
          onApply: () {
            Navigator.pop(context);
            setState(() {
              _isFiltered = _selectedYear != null || 
                           _selectedField != null || 
                           _selectedRank != null;
              _competitionsFuture = _service.fetchCompetitions(
                search: _searchController.text,
                year: _selectedYear,
                field: _selectedField,
                rank: _selectedRank,
              );
            });
          },
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedYear = null;
      _selectedField = null;
      _selectedRank = null;
      _isFiltered = false;
      _searchController.clear();
      _competitionsFuture = _service.fetchCompetitions();
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _searchController.clear();
      _selectedYear = null;
      _selectedField = null;
      _selectedRank = null;
      _isFiltered = false;
      _isSearching = false;
      _competitionsFuture = _service.fetchCompetitions();
    });
    await _loadFilterData();
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm theo tên, đơn vị...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF1E88E5)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          filled: true,
          fillColor: const Color(0xFFF5F7FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 1),
          ),
        ),
      ),
    );
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
                        _competitionsFuture = _service.fetchCompetitions(
                          search: _searchController.text,
                          field: _selectedField,
                          rank: _selectedRank,
                        );
                      });
                    },
                  ),
                if (_selectedField != null)
                  Chip(
                    label: Text(_selectedField!),
                    onDeleted: () {
                      setState(() {
                        _selectedField = null;
                        _competitionsFuture = _service.fetchCompetitions(
                          search: _searchController.text,
                          year: _selectedYear,
                          rank: _selectedRank,
                        );
                      });
                    },
                  ),
                if (_selectedRank != null)
                  Chip(
                    label: Text(_selectedRank!),
                    onDeleted: () {
                      setState(() {
                        _selectedRank = null;
                        _competitionsFuture = _service.fetchCompetitions(
                          search: _searchController.text,
                          year: _selectedYear,
                          field: _selectedField,
                        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Hội thi sáng tạo kỹ thuật',
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
          _buildSearchBar(),
          _buildActiveFilters(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: FutureBuilder<List<TechnicalCompetitionModel>>(
                future: _competitionsFuture,
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
                            onPressed: _refreshData,
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    );
                  }

                  final competitions = snapshot.data ?? [];

                  if (competitions.isEmpty && (_isSearching || _isFiltered)) {
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
                            'Không tìm thấy hồ sơ phù hợp',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (competitions.isEmpty) {
                    return const Center(
                      child: Text('Không có dữ liệu hội thi'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: competitions.length,
                    itemBuilder: (context, index) {
                      return CompetitionCard(
                        competition: competitions[index],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}