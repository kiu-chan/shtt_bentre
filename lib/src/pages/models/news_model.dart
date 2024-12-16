class NewsModel {
  final String id;
  final String image;
  final String title;
  final String content;
  final String htmlContent;
  final DateTime publishDate;
  final int views;

  NewsModel({
    required this.id,
    required this.image,
    required this.title,
    required this.content,
    this.htmlContent = '', // Default empty string if not provided
    required this.publishDate,
    required this.views,
  });
}