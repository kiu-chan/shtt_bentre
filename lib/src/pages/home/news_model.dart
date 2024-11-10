class NewsModel {
  final String id;
  final String image;
  final String title;
  final String content;
  final DateTime publishDate;
  final int views;

  NewsModel({
    required this.id,
    required this.image,
    required this.title,
    required this.content,
    required this.publishDate,
    required this.views,
  });
}