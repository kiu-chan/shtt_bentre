import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/home/geoIndication/geo_indication.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:shtt_bentre/src/pages/home/category/geo_indication/geo_indication_card.dart';
import 'package:shtt_bentre/src/pages/home/category/geo_indication/geo_indication_detail_page.dart';
import 'dart:async';

class GeoIndicationListPage extends StatefulWidget {
  const GeoIndicationListPage({super.key});

  @override
  State<GeoIndicationListPage> createState() => _GeoIndicationListPageState();
}

class _GeoIndicationListPageState extends State<GeoIndicationListPage> {
  final Database _service = Database();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<GeoIndicationModel>> _geoIndicationsFuture;
  Timer? _debounce;
  String? _selectedYear;
  String? _selectedDistrict;
  List<String> _availableYears = [];
  List<Map<String, dynamic>> _availableDistricts = [];
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    _geoIndicationsFuture = _service.fetchGeoIndications();
    _searchController.addListener(_onSearchChanged);
    _loadFilterData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadFilterData() async {
    try {
      final years = await _service.geo.fetchAvailableYears();
      final districts = await _service.geo.fetchAvailableDistricts();
      setState(() {
        _availableYears = years;
        _availableDistricts = districts;
      });
    } catch (e) {
      print('Error loading filter data: $e');
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _geoIndicationsFuture = _service.geo.fetchGeoIndications(
          search: _searchController.text,
        );
      });
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Bộ lọc'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Năm:'),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedYear,
                      hint: const Text('Chọn năm'),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Tất cả'),
                        ),
                        ..._availableYears.map((year) {
                          return DropdownMenuItem<String>(
                            value: year,
                            child: Text('Năm $year'),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) => setState(() => _selectedYear = value),
                    ),
                    const SizedBox(height: 16),
                    const Text('Huyện:'),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedDistrict,
                      hint: const Text('Chọn huyện'),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Tất cả'),
                        ),
                        ..._availableDistricts.map((district) {
                          return DropdownMenuItem<String>(
                            value: district['name'],
                            child: Text('${district['name']} (${district['count']})'),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) => setState(() => _selectedDistrict = value),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _applyFilters();
                  },
                  child: const Text('Áp dụng'),
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
      if (_selectedYear != null) {
        _geoIndicationsFuture = _service.geo.fetchGeoIndicationsByYear(_selectedYear!);
      } else if (_selectedDistrict != null) {
        _geoIndicationsFuture = _service.geo.fetchGeoIndicationsByDistrict(_selectedDistrict!);
      } else {
        _geoIndicationsFuture = _service.fetchGeoIndications();
      }
      _isFiltered = _selectedYear != null || _selectedDistrict != null;
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedYear = null;
      _selectedDistrict = null;
      _isFiltered = false;
      _geoIndicationsFuture = _service.fetchGeoIndications();
    });
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm theo tên sản phẩm hoặc số đơn...',
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

  Future<void> _refreshData() async {
    setState(() {
      _searchController.clear();
      _selectedYear = null;
      _selectedDistrict = null;
      _isFiltered = false;
      _geoIndicationsFuture = _service.fetchGeoIndications();
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
          'Chỉ dẫn địa lý',
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
              child: FutureBuilder<List<GeoIndicationModel>>(
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
                            onPressed: _refreshData,
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    );
                  }

                  final geoIndications = snapshot.data ?? [];
                  if (geoIndications.isEmpty &&
                      (_searchController.text.isNotEmpty || _isFiltered)) {
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
                            'Không tìm thấy chỉ dẫn địa lý phù hợp',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

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
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GeoIndicationDetailPage(stt: item.stt),
                          ),
                        ),
                        child: GeoIndicationCard(data: item),
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