// lib/src/pages/home/category/patent/patent_list_page.dart

import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/home/patent/patent.dart';
import 'package:shtt_bentre/src/mainData/database/home/patents.dart';
import 'package:shtt_bentre/src/pages/home/category/patent/patent_card.dart';
import 'package:shtt_bentre/src/pages/home/category/patent/patent_detail_page.dart';

class PatentListPage extends StatefulWidget {
  const PatentListPage({super.key});

  @override
  State<PatentListPage> createState() => _PatentListPageState();
}

class _PatentListPageState extends State<PatentListPage> {
  final PatentsDatabase _patentService = PatentsDatabase();
  late Future<List<PatentModel>> _patentsFuture;
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;

  @override
  void initState() {
    super.initState();
    _patentsFuture = _patentService.fetchPatents();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= 400) {
      if (!_showBackToTopButton) {
        setState(() {
          _showBackToTopButton = true;
        });
      }
    } else {
      if (_showBackToTopButton) {
        setState(() {
          _showBackToTopButton = false;
        });
      }
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
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
      _patentsFuture = _patentService.fetchPatents();
    });
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
      ),
      body: RefreshIndicator(
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

            final patents = snapshot.data ?? [];
            if (patents.isEmpty) {
              return const Center(
                child: Text('Không có dữ liệu sáng chế'),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: patents.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onPatentTap(patents[index]),
                  child: PatentCard(patent: patents[index]),
                );
              },
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