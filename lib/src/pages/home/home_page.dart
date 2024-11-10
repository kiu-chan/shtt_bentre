import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/pages/home/menu/menu_drawer.dart';
import 'package:shtt_bentre/src/pages/home/news_list_page.dart';
import 'package:shtt_bentre/src/pages/home/news_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<NewsModel> sliderItems = [
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

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const MenuDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildNewsSection(),
            _buildNewsSlider(),
            _buildSliderIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'lib/assets/logo.png',
                height: 40,
                width: 40,
              ),
              const SizedBox(width: 10),
              const Text(
                'SHTT - BẾN TRE',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tin tức',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewsListPage(),
                ),
              );
            },
            child: const Text('Xem tất cả'),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsSlider() {
    return CarouselSlider.builder(
      itemCount: sliderItems.length,
      options: CarouselOptions(
        height: 280.0,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16/9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.8,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      itemBuilder: (context, index, realIndex) {
        final news = sliderItems[index];
        return GestureDetector(
          onTap: () {
            // TODO: Navigate to news detail
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNewsImage(news),
                _buildNewsContent(news),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNewsImage(NewsModel news) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(news.image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildNewsContent(NewsModel news) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ),
      child: Column(
        children: [
          Text(
            news.title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoItem(
                Icons.calendar_today,
                DateFormat('dd/MM/yyyy').format(news.publishDate),
              ),
              const SizedBox(width: 16),
              _buildInfoItem(
                Icons.remove_red_eye,
                '${NumberFormat('#,###').format(news.views)} lượt xem',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 12,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSliderIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: sliderItems.asMap().entries.map((entry) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 4.0
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withOpacity(
              _currentIndex == entry.key ? 0.9 : 0.4
            ),
          ),
        );
      }).toList(),
    );
  }
}