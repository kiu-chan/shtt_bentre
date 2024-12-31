import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/home/trademark/trademark.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:shtt_bentre/src/pages/home/category/trademark/trademark_detail.dart';
import 'package:shtt_bentre/src/pages/home/category/trademark/trademark_card.dart';

class TrademarkListPage extends StatefulWidget {
  const TrademarkListPage({super.key});

  @override
  State<TrademarkListPage> createState() => _TrademarkListPageState();
}

class _TrademarkListPageState extends State<TrademarkListPage> {
  final Database _service = Database();
  final List<TrademarkModel> _trademarks = [];
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      final trademarks = await _service.fetchTrademarks();
      if (!mounted) return;
      
      setState(() {
        _trademarks.clear();
        _trademarks.addAll(trademarks);
        _isLoading = false;
        _currentPage = 1;
        _hasMoreData = trademarks.isNotEmpty;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final moreTrademarks = await _service.fetchTrademarks(page: nextPage);
      
      if (!mounted) return;

      setState(() {
        if (moreTrademarks.isEmpty) {
          _hasMoreData = false;
        } else {
          _trademarks.addAll(moreTrademarks);
          _currentPage = nextPage;
        }
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể tải thêm dữ liệu: ${e.toString()}'),
            action: SnackBarAction(
              label: 'Thử lại',
              onPressed: _loadMoreData,
            ),
          ),
        );
      });
    }
  }

  void _scrollListener() {
    // Back to top button logic
    if (_scrollController.offset >= 400) {
      if (!_showBackToTopButton) {
        setState(() => _showBackToTopButton = true);
      }
    } else {
      if (_showBackToTopButton) {
        setState(() => _showBackToTopButton = false);
      }
    }

    // Load more data logic
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
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

  Future<void> _refreshData() async {
    _currentPage = 1;
    _hasMoreData = true;
    await _loadInitialData();
  }

  void _onTrademarkTap(TrademarkModel trademark) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrademarkDetailPage(id: trademark.id),
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

  Widget _buildErrorView() {
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
            'Có lỗi xảy ra: ${_errorMessage ?? "Unknown error"}',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Bảo hộ nhãn hiệu',
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
        onRefresh: _refreshData,
        child: _hasError && _trademarks.isEmpty
            ? _buildErrorView()
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _trademarks.length + (_hasMoreData ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _trademarks.length) {
                    return _isLoading ? _buildLoadingIndicator() : const SizedBox();
                  }
                  return GestureDetector(
                    onTap: () => _onTrademarkTap(_trademarks[index]),
                    child: TrademarkCard(trademark: _trademarks[index]),
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
}