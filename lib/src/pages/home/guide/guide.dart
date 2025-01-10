class GuideContent {
 final int id;
 final String title; 
 final String slug;
 String? content;
 final String? publishedAt;
 bool isLoading;

 GuideContent({
   required this.id,
   required this.title,
   required this.slug,
   this.content,
   this.publishedAt,
   this.isLoading = false,
 });

 factory GuideContent.fromJson(Map<String, dynamic> json) {
   return GuideContent(
     id: json['id'] ?? 0,
     title: json['title'] ?? '',
     slug: json['slug'] ?? '',
     content: json['content'],
     publishedAt: json['published_at'],
   );
 }
}