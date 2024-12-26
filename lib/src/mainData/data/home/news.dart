class NewsModel {
  final String id;
  final String title;
  final String slug;
  final String content;
  final String imageUrl;
  final DateTime publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int views;

  NewsModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.content,
    required this.imageUrl,
    required this.publishedAt,
    this.createdAt,
    this.updatedAt,
    required this.views,
  });

  String get fullImageUrl => 'https://shttbentre.girc.edu.vn/storage/$imageUrl';

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'] ?? '',
      publishedAt: DateTime.parse(json['published_at'] ?? DateTime.now().toIso8601String()),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      views: json['views'] ?? 0,
    );
  }
}