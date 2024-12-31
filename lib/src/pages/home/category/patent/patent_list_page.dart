import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/home/patent/patent.dart';
import 'package:shtt_bentre/src/mainData/database/home/patents.dart';
import 'package:shtt_bentre/src/pages/home/category/patent/patent_card.dart';
import 'package:shtt_bentre/src/pages/home/category/patent/patent_detail_page.dart';
import 'package:shtt_bentre/src/pages/home/category/patent/patent_filter_menu.dart';

class PatentListPage extends StatefulWidget {
  const PatentListPage({super.key});

  @override
  State<PatentListPage> createState() => _PatentListPageState();
}

class _PatentListPageState extends State<PatentListPage> {
  final PatentsDatabase _patentService = PatentsDatabase();
  late Future<List<PatentModel>> _patentsFuture;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _showBackToTopButton = false;
  List<PatentModel> _allPatents = [];
  List<PatentModel> _filteredPatents = [];
  bool _isSearching = false;

  String? _selectedField;
  String? _selectedYear;
  String? _selectedDistrict;
  Set<String> _availableFields = {};
  Set<String> _availableYears = {};
  Set<String> _availableDistricts = {};
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    _patentsFuture = _loadPatents();
    _scrollController.addListener(_scrollListener);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<PatentModel>> _loadPatents() async {
    final patents = await _patentService.fetchPatents();
    _allPatents = patents;
    _filteredPatents = patents;
    
    _availableFields = patents.map((p) => p.field).toSet();
    _availableYears = patents.map((p) => p.date.year.toString()).toSet();
    _availableDistricts = patents.map((p) => _extractDistrict(p.address)).toSet();
    
    return patents;
  }

  String _extractDistrict(String address) {
    List<String> parts = address.split(',');
    for (String part in parts) {
      part = part.trim();
      if (part.toLowerCase().contains('huyện') || 
          part.toLowerCase().contains('thành phố') ||
          part.toLowerCase().contains('thị xã')) {
        return part.trim();
      }
    }
    return 'Khác';
  }

  void _scrollListener() {
    setState(() {
      _showBackToTopButton = _scrollController.offset >= 400;
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _applyFilters() {
    setState(() {
      _filteredPatents = _allPatents.where((patent) {
        bool matchesSearch = true;
        if (_searchController.text.isNotEmpty) {
          final query = _searchController.text.toLowerCase();
          matchesSearch = patent.title.toLowerCase().contains(query) ||
              patent.owner.toLowerCase().contains(query) ||
              patent.filingNumber.toLowerCase().contains(query) ||
              patent.field.toLowerCase().contains(query);
        }

        bool matchesField = _selectedField == null || patent.field == _selectedField;
        bool matchesYear = _selectedYear == null || 
            patent.date.year.toString() == _selectedYear;
        bool matchesDistrict = _selectedDistrict == null || 
            _extractDistrict(patent.address) == _selectedDistrict;

        return matchesSearch && matchesField && matchesYear && matchesDistrict;
      }).toList();

      _isFiltered = _selectedField != null || 
                    _selectedYear != null || 
                    _selectedDistrict != null;
    });
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _resetFilters() {
    setState(() {
      _selectedField = null;
      _selectedYear = null;
      _selectedDistrict = null;
      _isFiltered = false;
      _applyFilters();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return PatentFilterMenu(
              selectedField: _selectedField,
              selectedYear: _selectedYear,
              selectedDistrict: _selectedDistrict,
              availableFields: _availableFields,
              availableYears: _availableYears,
              availableDistricts: _availableDistricts,
              onFieldChanged: (value) => setState(() => _selectedField = value),
              onYearChanged: (value) => setState(() => _selectedYear = value),
              onDistrictChanged: (value) => setState(() => _selectedDistrict = value),
              onApply: () {
                Navigator.pop(context);
                _applyFilters();
              },
              onCancel: () => Navigator.pop(context),
            );
          },
        );
      },
    );
  }

  void _onPatentTap(PatentModel patent) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatentDetailPage(id: patent.id),
      ),
    );
  }

  Future<void> _refreshPatents() async {
    setState(() {
      _patentsFuture = _loadPatents();
      _searchController.clear();
      _resetFilters();
    });
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm theo tên, chủ sở hữu, số đơn...',
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
        onChanged: (value) {
          setState(() {
            _isSearching = value.isNotEmpty;
          });
        },
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
                if (_selectedField != null)
                  Chip(
                    label: Text(_selectedField!),
                    onDeleted: () {
                      setState(() {
                        _selectedField = null;
                        _applyFilters();
                      });
                    },
                  ),
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
                if (_selectedDistrict != null)
                  Chip(
                    label: Text(_selectedDistrict!),
                    onDeleted: () {
                      setState(() {
                        _selectedDistrict = null;
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
              onRefresh: _refreshPatents,
              child: FutureBuilder<List<PatentModel>>(
                future: _patentsFuture,
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
                            onPressed: _refreshPatents,
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (_filteredPatents.isEmpty && (_isSearching || _isFiltered)) {
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
                            'Không tìm thấy sáng chế phù hợp',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (_filteredPatents.isEmpty) {
                    return const Center(
                      child: Text('Không có dữ liệu sáng chế'),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredPatents.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _onPatentTap(_filteredPatents[index]),
                        child: PatentCard(patent: _filteredPatents[index]),
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