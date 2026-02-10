class BlogPost {
  final int id;
  final String title;
  final String content;
  final String? imageUrl;
  final String blogDate;

  const BlogPost({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.blogDate,
  });
}
