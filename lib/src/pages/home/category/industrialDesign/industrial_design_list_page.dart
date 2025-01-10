import 'dart:async';
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
  final ScrollController _scrollController = ScrollController();
  
  // Pagination state
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;
  List<IndustrialDesignModel> _designs = [];

  // Filter state
  String? _selectedType;
  String? _selectedYear;
  String? _selectedDistrict;
  List<Map<String, dynamic>> _availableTypes = [];
  List<String> _availableYears = [];
  List<Map<String, dynamic>> _availableDistricts = [];
  bool _isFiltered = false;

  // Search state
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadFilterData();
    _loadInitialData();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadFilterData() async {
    try {
      final types = await _service.industrialDesign.fetchDesignTypes();
      final years = await _service.industrialDesign.fetchDesignYears();
      final districts = await _service.industrialDesign.fetchDesignDistricts();

      if (mounted) {
        setState(() {
          _availableTypes = types;
          _availableYears = years;
          _availableDistricts = districts;
        });
      }
    } catch (e) {
      print('Error loading filter data: $e');
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMoreData) {
      _loadMoreData();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _designs = [];
    });

    try {
      final designs = await _service.fetchIndustrialDesigns(
        search: _searchController.text.isNotEmpty ? _searchController.text : null,
        type: _selectedType,
        year: _selectedYear,
        district: _selectedDistrict,
        page: _currentPage,
      );

      setState(() {
        _designs = designs;
        _hasMoreData = designs.isNotEmpty;
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
      final moreDesigns = await _service.fetchIndustrialDesigns(
        search: _searchController.text.isNotEmpty ? _searchController.text : null,
        type: _selectedType,
        year: _selectedYear,
        district: _selectedDistrict,
        page: nextPage,
      );

      setState(() {
        if (moreDesigns.isNotEmpty) {
          _designs.addAll(moreDesigns);
          _currentPage = nextPage;
          _hasMoreData = moreDesigns.length >= 10; // Assuming 10 items per page
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

  Future<void> _refreshData() async {
    await _loadInitialData();
  }

  void _showFilterDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.filter),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Loại kiểu dáng:'),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedType,
                      hint: const Text('Chọn loại kiểu dáng'),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(l10n.all),
                        ),
                        ..._availableTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type['type'],
                            child: Text('${type['type']} (${type['count']})'),
                          );
                        }),
                      ],
                      onChanged: (value) => setState(() => _selectedType = value),
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.year),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedYear,
                      hint: Text(l10n.selectYear),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(l10n.all),
                        ),
                        ..._availableYears.map((year) {
                          return DropdownMenuItem<String>(
                            value: year,
                            child: Text('${l10n.year} $year'),
                          );
                        }),
                      ],
                      onChanged: (value) => setState(() => _selectedYear = value),
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.districtLabel),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedDistrict,
                      hint: Text(l10n.selectDistrict),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(l10n.all),
                        ),
                        ..._availableDistricts.map((district) {
                          return DropdownMenuItem<String>(
                            value: district['district_name'],
                            child: Text('${district['district_name']} (${district['count']})'),
                          );
                        }),
                      ],
                      onChanged: (value) => setState(() => _selectedDistrict = value),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _applyFilters();
                  },
                  child: Text(l10n.apply),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _applyFilters() {
    setState(() {
      _isFiltered = _selectedType != null || _selectedYear != null || _selectedDistrict != null;
      _loadInitialData();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedType = null;
      _selectedYear = null;
      _selectedDistrict = null;
      _isFiltered = false;
      _searchController.clear();
      _loadInitialData();
    });
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm theo tên, chủ sở hữu, địa chỉ, số đơn...',
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
                if (_selectedType != null)
                  Chip(
                    label: Text(_selectedType!),
                    onDeleted: () {
                      setState(() {
                        _selectedType = null;
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

  Widget _buildDesignCard(IndustrialDesignModel design) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IndustrialDesignDetailPage(id: design.id.toString()),
        ),
      ),
      child: Card(
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
                      color: const Color(0xFF1E88E5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF1E88E5).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      'Kiểu dáng công nghiệp',
                      style: TextStyle(
                        color: Color(0xFF1565C0),
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
                          DateFormat('dd/MM/yyyy').format(design.filingDate),
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
                    'Số đơn: ${design.filingNumber}',
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
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'đã cấp bằng':
        return const Color(0xFF4CAF50);
      case 'đang chờ xử lý':
        return const Color(0xFFFFA726);
      case 'từ chối':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
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
            _isSearching
                ? 'Không tìm thấy kiểu dáng phù hợp'
                : 'Không có dữ liệu kiểu dáng công nghiệp',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
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
              child: _designs.isEmpty && !_isLoading
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _designs.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _designs.length) {
                          return _buildLoadingIndicator();
                        }
                        return _buildDesignCard(_designs[index]);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}