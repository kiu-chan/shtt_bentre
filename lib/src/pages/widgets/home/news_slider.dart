import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shtt_bentre/src/mainData/data/home/news.dart';
import 'package:shtt_bentre/src/mainData/database/home/news.dart';
import '../../home/news/news_detail_page.dart';
import 'dart:math';

class NewsSlider extends StatefulWidget {
  const NewsSlider({super.key});

  @override
  NewsSliderState createState() => NewsSliderState();
}

class NewsSliderState extends State<NewsSlider> {
  final NewsService _newsService = NewsService();
  int _currentIndex = 0;
  List<NewsModel> _sliderItems = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final newsData = await _newsService.fetchNews();
      final allNews = newsData.map((item) => NewsModel.fromJson(item)).toList();
      
      // Randomly select 3 news items
      final random = Random();
      final selectedNews = <NewsModel>[];
      final newsCount = min(3, allNews.length);
      
      while (selectedNews.length < newsCount) {
        final randomIndex = random.nextInt(allNews.length);
        if (!selectedNews.contains(allNews[randomIndex])) {
          selectedNews.add(allNews[randomIndex]);
        }
      }

      setState(() {
        _sliderItems = selectedNews;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Có lỗi xảy ra\n$_error',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red[700]),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _loadNews,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (_sliderItems.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text('Không có tin tức'),
        ),
      );
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _sliderItems.length,
          options: CarouselOptions(
            height: 200.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16/9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.85,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return _buildNewsCard(_sliderItems[index]);
          },
        ),
        const SizedBox(height: 16),
        _buildSliderIndicator(),
      ],
    );
  }

  Widget _buildNewsCard(NewsModel news) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(newsId: news.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                news.fullImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Text(
                  news.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _sliderItems.asMap().entries.map((entry) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withOpacity(
              _currentIndex == entry.key ? 0.9 : 0.3
            ),
          ),
        );
      }).toList(),
    );
  }
}