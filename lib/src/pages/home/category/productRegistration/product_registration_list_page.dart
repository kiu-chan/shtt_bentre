import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/mainData/data/home/product/product.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
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
                        child: _ProductRegistrationCard(
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

class _ProductRegistrationCard extends StatelessWidget {
  final ProductRegistrationModel product;

  const _ProductRegistrationCard({
    required this.product,
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
                    color: const Color(0xFFFFA726).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFFA726).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.business_center,
                        size: 16,
                        color: Color(0xFFE65100),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Sản phẩm',
                        style: TextStyle(
                          color: Color(0xFFE65100),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'Mã: ${product.id}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              product.name,
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
                          'Chủ sở hữu: ${product.owner}',
                          style: const TextStyle(
                            color: Color(0xFF455A64),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (product.address.isNotEmpty) ...[
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
                            product.address,
                            style: const TextStyle(
                              color: Color(0xFF455A64),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                          'Đại diện: ${product.representative}',
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
                    'Thời gian: ${DateFormat('dd.MM.yyyy HH:mm').format(product.createdAt)}',
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