import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/mainData/data/home/product/product.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:shtt_bentre/src/pages/home/category/productRegistration/product_card.dart';
import 'package:shtt_bentre/src/pages/home/category/productRegistration/product_detail_page.dart';

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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadMoreProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Show/hide back to top button
    setState(() {
      _showBackToTopButton = _scrollController.offset >= 400;
    });

    // Load more data when reaching the bottom
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
      final newProducts = await _service.product.fetchProducts(page: _currentPage);
      
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
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: _products.isEmpty && _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _products.isEmpty
                ? const Center(child: Text('Không có dữ liệu sản phẩm'))
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
      floatingActionButton: _showBackToTopButton
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: const Color(0xFF1E88E5),
              child: const Icon(Icons.arrow_upward),
            )
          : null,
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}