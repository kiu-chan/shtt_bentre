class AboutModel {
  final String title;
  final String content;
  final String createdAt;
  final String updatedAt;

  AboutModel({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    return AboutModel(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}