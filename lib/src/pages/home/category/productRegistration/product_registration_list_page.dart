import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/home/product/product.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:shtt_bentre/src/pages/home/category/productRegistration/product_card.dart';
import 'package:shtt_bentre/src/pages/home/category/productRegistration/product_detail_page.dart';
import 'package:shtt_bentre/src/pages/home/category/productRegistration/product_filter_menu.dart';

class ProductRegistrationListPage extends StatefulWidget {
  const ProductRegistrationListPage({super.key});

  @override
  State<ProductRegistrationListPage> createState() => _ProductRegistrationListPageState();
}

class _ProductRegistrationListPageState extends State<ProductRegistrationListPage> {
  final Database _service = Database();
  final List<ProductRegistrationModel> _products = [];
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;

  // Filter-related state
  String? _selectedYear;
  String? _selectedDistrict;
  List<String> _availableYears = [];
  List<Map<String, dynamic>> _availableDistricts = [];
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadFilterData();
    _loadMoreProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadFilterData() async {
    try {
      final years = await _service.product.fetchAvailableYears();
      final districts = await _service.product.fetchAvailableDistricts();
      
      if (mounted) {
        setState(() {
          _availableYears = years;
          _availableDistricts = districts;
        });
      }
    } catch (e) {
      print('Error loading filter data: $e');
    }
  }

  void _scrollListener() {
    setState(() {
      _showBackToTopButton = _scrollController.offset >= 400;
    });

    if (!_isLoading && _hasMore &&
        _scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newProducts = await _service.product.fetchProducts(
        page: _currentPage,
        year: _selectedYear,
        district: _selectedDistrict,
      );
      
      setState(() {
        if (newProducts.isEmpty) {
          _hasMore = false;
        } else {
          _products.addAll(newProducts);
          _currentPage++;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra: $e'),
          action: SnackBarAction(
            label: 'Thử lại',
            onPressed: _loadMoreProducts,
          ),
        ),
      );
    }
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _products.clear();
      _currentPage = 1;
      _hasMore = true;
    });
    await _loadMoreProducts();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ProductFilterMenu(
              selectedYear: _selectedYear,
              selectedDistrict: _selectedDistrict,
              availableYears: _availableYears,
              availableDistricts: _availableDistricts,
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

  void _applyFilters() {
    setState(() {
      _products.clear();
      _currentPage = 1;
      _hasMore = true;
      _isFiltered = _selectedYear != null || _selectedDistrict != null;
      _loadMoreProducts();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedYear = null;
      _selectedDistrict = null;
      _isFiltered = false;
      _products.clear();
      _currentPage = 1;
      _hasMore = true;
      _loadMoreProducts();
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

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
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
          'Sản phẩm đăng ký xây dựng',
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
              onRefresh: _refreshProducts,
              child: _products.isEmpty && _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _products.isEmpty
                      ? Center(
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
                                _isFiltered
                                    ? 'Không tìm thấy sản phẩm phù hợp'
                                    : 'Không có dữ liệu sản phẩm',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _products.length + (_hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _products.length) {
                              return _buildLoadingIndicator();
                            }
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailPage(
                                    id: _products[index].id,
                                  ),
                                ),
                              ),
                              child: ProductRegistrationCard(
                                product: _products[index],
                              ),
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