import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shtt_bentre/src/mainData/data/home/warning.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:shtt_bentre/src/pages/home/warning/warning_card.dart';
import 'package:shtt_bentre/src/pages/home/warning/warning_filter_menu.dart';

class WarningPage extends StatefulWidget {
  const WarningPage({super.key});

  @override
  State<WarningPage> createState() => _WarningPageState();
}

class _WarningPageState extends State<WarningPage> {
  late Future<List<WarningModel>> _warningsFuture;
  final TextEditingController _searchController = TextEditingController();
  final Database db = Database();
  Timer? _debounce;
  
  String? _selectedStatus;
  String? _selectedAssetType;
  String? _selectedType;
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    _loadWarnings();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _loadWarnings();
    });
  }

  void _loadWarnings() {
    setState(() {
      _warningsFuture = db.fetchWarnings(
        search: _searchController.text.isNotEmpty ? _searchController.text : null,
        status: _selectedStatus,
        assetType: _selectedAssetType,
        type: _selectedType
      );
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WarningFilterMenu(
          selectedStatus: _selectedStatus,
          selectedAssetType: _selectedAssetType,
          selectedType: _selectedType,
          onStatusChanged: (value) => setState(() => _selectedStatus = value),
          onAssetTypeChanged: (value) => setState(() => _selectedAssetType = value),
          onTypeChanged: (value) => setState(() => _selectedType = value),
          onApply: () {
            Navigator.pop(context);
            _isFiltered = _selectedStatus != null || 
                         _selectedAssetType != null || 
                         _selectedType != null;
            _loadWarnings();
          },
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedStatus = null;
      _selectedAssetType = null;
      _selectedType = null;
      _searchController.clear();
      _isFiltered = false;
      _loadWarnings();
    });
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm theo tiêu đề...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF1E88E5)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
                    _loadWarnings();
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
                if (_selectedStatus != null)
                  Chip(
                    label: Text(_getStatusText(_selectedStatus!)),
                    onDeleted: () {
                      setState(() {
                        _selectedStatus = null;
                        _isFiltered = _selectedAssetType != null || 
                                    _selectedType != null;
                        _loadWarnings();
                      });
                    },
                  ),
                if (_selectedAssetType != null)
                  Chip(
                    label: Text(_selectedAssetType!),
                    onDeleted: () {
                      setState(() {
                        _selectedAssetType = null;
                        _isFiltered = _selectedStatus != null || 
                                    _selectedType != null;
                        _loadWarnings();
                      });
                    },
                  ),
                if (_selectedType != null)
                  Chip(
                    label: Text(_getTypeText(_selectedType!)),
                    onDeleted: () {
                      setState(() {
                        _selectedType = null;
                        _isFiltered = _selectedStatus != null || 
                                    _selectedAssetType != null;
                        _loadWarnings();
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

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'ĐANG CHỜ';
      case 'completed':
        return 'HOÀN THÀNH';
      case 'rejected':
        return 'TỪ CHỐI';
      default:
        return status.toUpperCase();
    }
  }

  String _getTypeText(String type) {
    switch (type.toLowerCase()) {
      case 'alert':
        return 'CẢNH BÁO';
      case 'report':
        return 'BÁO CÁO';
      default:
        return type.toUpperCase();
    }
  }

  Future<void> _refreshWarnings() async {
    _loadWarnings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Cảnh báo & Báo cáo',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
              onRefresh: _refreshWarnings,
              child: FutureBuilder<List<WarningModel>>(
                future: _warningsFuture,
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
                            onPressed: _refreshWarnings,
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    );
                  }

                  final warnings = snapshot.data ?? [];
                  
                  if (warnings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _searchController.text.isNotEmpty || _isFiltered
                                ? Icons.search_off
                                : Icons.notifications_off_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchController.text.isNotEmpty || _isFiltered
                                ? 'Không tìm thấy cảnh báo phù hợp'
                                : 'Chưa có cảnh báo nào',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: warnings.length,
                    itemBuilder: (context, index) {
                      final warning = warnings[index];
                      return WarningCard(
                        id: warning.id,
                        type: warning.type,
                        title: warning.title,
                        description: warning.description,
                        status: warning.status,
                        createdAt: warning.createdAt,
                        assetType: warning.assetType,
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