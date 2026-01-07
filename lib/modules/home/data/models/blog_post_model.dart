import '../../domain/entities/blog_post.dart';

class BlogPostModel extends BlogPost {
  const BlogPostModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    required super.blogDate,
  });

  factory BlogPostModel.fromJson(Map<String, dynamic> json) {
    return BlogPostModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      blogDate: json['blog_date']?.toString() ?? '',
    );
  }
}
