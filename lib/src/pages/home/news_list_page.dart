import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/pages/home/news/news_detail_page.dart';
import 'package:shtt_bentre/src/pages/home/news_model.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key});

  List<NewsModel> get _newsList => [
    NewsModel(
      id: '1',
      image: 'lib/assets/bt1.jpg',
      title: 'Chợ nổi Cái Răng - Điểm đến không thể bỏ qua khi ghé thăm Bến Tre',
      content: 'Chợ nổi Cái Răng là một trong những điểm du lịch hấp dẫn nhất tại Bến Tre. Đây là nơi du khách có thể trải nghiệm nét văn hóa đặc trưng của vùng sông nước miền Tây, với những ghe thuyền buôn bán đặc sản địa phương...',
      publishDate: DateTime(2024, 11, 10),
      views: 1234,
    ),
    NewsModel(
      id: '2',
      image: 'lib/assets/bt2.jpg',
      title: 'Làng nghề dừa - Khám phá nghề truyền thống của người dân địa phương',
      content: 'Làng nghề dừa tại Bến Tre là điểm đến không thể bỏ qua cho du khách muốn tìm hiểu về nghề truyền thống của người dân địa phương. Tại đây, du khách sẽ được tận mắt chứng kiến quá trình chế biến các sản phẩm từ dừa...',
      publishDate: DateTime(2024, 11, 9),
      views: 856,
    ),
    NewsModel(
      id: '3',
      image: 'lib/assets/bt3.jpg',
      title: 'Cồn Phụng - Hòn đảo xinh đẹp giữa sông nước miền Tây',
      content: 'Cồn Phụng là một trong những điểm du lịch sinh thái hấp dẫn tại Bến Tre. Hòn đảo này nổi tiếng với không gian xanh mát, những vườn cây ăn trái sum suê và các hoạt động trải nghiệm văn hóa địa phương đặc sắc...',
      publishDate: DateTime(2024, 11, 8),
      views: 2145,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin tức'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _newsList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return NewsCard(news: _newsList[index]);
        },
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final NewsModel news;

  const NewsCard({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              news.image,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd/MM/yyyy').format(news.publishDate),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.remove_red_eye,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${NumberFormat('#,###').format(news.views)} lượt xem',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  news.content,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailPage(news: news),
                        ),
                      );
                    },
                    child: const Text('Xem thêm'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}