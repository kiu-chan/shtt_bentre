import 'package:flutter/material.dart';
import 'dart:async';
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
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  // Pagination state
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;
  List<InitiativeModel> _initiatives = [];
  
  Timer? _debounce;
  bool _showBackToTopButton = false;
  String? _selectedYear;
  List<String> _availableYears = [];
  bool _isFiltered = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_scrollListener);
    _searchController.addListener(_onSearchChanged);
    _loadFilterData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
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
    setState(() {
      _showBackToTopButton = _scrollController.offset >= 400;
    });
    
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading && 
        _hasMoreData) {
      _loadMoreData();
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _initiatives = [];
    });

    try {
      final initiatives = await _initiativeService.initiative.fetchInitiatives(
        search: _searchController.text.isNotEmpty ? _searchController.text : null,
        year: _selectedYear,
        page: _currentPage,
      );

      setState(() {
        _initiatives = initiatives;
        _hasMoreData = initiatives.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasMoreData = false;
      });
      print('Error loading initial data: $e');
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final moreInitiatives = await _initiativeService.initiative.fetchInitiatives(
        search: _searchController.text.isNotEmpty ? _searchController.text : null,
        year: _selectedYear,
        page: nextPage,
      );

      setState(() {
        if (moreInitiatives.isNotEmpty) {
          _initiatives.addAll(moreInitiatives);
          _currentPage = nextPage;
          _hasMoreData = moreInitiatives.length >= 10;
        } else {
          _hasMoreData = false;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasMoreData = false;
      });
      print('Error loading more data: $e');
    }
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
    });
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _loadInitialData();
    });
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
      _isFiltered = _selectedYear != null;
      _loadInitialData();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedYear = null;
      _isFiltered = false;
      _searchController.clear();
      _loadInitialData();
    });
  }

  void _onInitiativeTap(InitiativeModel initiative) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InitiativeDetailPage(id: initiative.id),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm theo tên, tác giả, chủ sở hữu, địa chỉ...',
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

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isSearching ? Icons.search_off : Icons.inbox,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _isSearching || _isFiltered
                ? 'Không tìm thấy sáng kiến phù hợp'
                : 'Không có dữ liệu sáng kiến',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshInitiatives() async {
    setState(() {
      _searchController.clear();
      _selectedYear = null;
      _isFiltered = false;
    });
    await _loadFilterData();
    await _loadInitialData();
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
          _buildSearchBar(),
          _buildActiveFilters(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshInitiatives,
              child: _initiatives.isEmpty && !_isLoading
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _initiatives.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _initiatives.length) {
                          return _buildLoadingIndicator();
                        }
                        return GestureDetector(
                          onTap: () => _onInitiativeTap(_initiatives[index]),
                          child: InitiativeCard(initiative: _initiatives[index]),
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