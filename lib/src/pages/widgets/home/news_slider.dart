// widgets/news_slider.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shtt_bentre/src/pages/models/news_model.dart';
import '../../home/news/news_detail_page.dart';

class NewsSlider extends StatefulWidget {
  const NewsSlider({super.key});

  @override
  NewsSliderState createState() => NewsSliderState();
}

class NewsSliderState extends State<NewsSlider> {
  int _currentIndex = 0;

  static final List<NewsModel> sliderItems = [
    NewsModel(
      id: '1',
      image: 'lib/assets/bt1.jpg',
      title: 'Chợ nổi Cái Răng - Điểm đến không thể bỏ qua khi ghé thăm Bến Tre',
      content: 'Chợ nổi Cái Răng là một trong những điểm du lịch hấp dẫn nhất tại Bến Tre...',
      publishDate: DateTime(2024, 11, 10),
      views: 1234,
    ),
    NewsModel(
      id: '2',
      image: 'lib/assets/bt2.jpg', 
      title: 'Làng nghề dừa - Khám phá nghề truyền thống của người dân địa phương',
      content: 'Làng nghề dừa tại Bến Tre là điểm đến không thể bỏ qua cho du khách...',
      publishDate: DateTime(2024, 11, 9),
      views: 856,
    ),
    NewsModel(
      id: '3', 
      image: 'lib/assets/bt3.jpg',
      title: 'Cồn Phụng - Hòn đảo xinh đẹp giữa sông nước miền Tây',
      content: 'Cồn Phụng là một trong những điểm du lịch sinh thái hấp dẫn tại Bến Tre...',
      publishDate: DateTime(2024, 11, 8),
      views: 2145,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: sliderItems.length,
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
            return _buildNewsCard(sliderItems[index]);
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
            builder: (context) => NewsDetailPage(news: news),
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
              Image.asset(
                news.image,
                fit: BoxFit.cover,
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
      children: sliderItems.asMap().entries.map((entry) {
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