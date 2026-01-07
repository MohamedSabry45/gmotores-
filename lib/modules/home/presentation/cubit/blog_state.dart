import '../../domain/entities/blog_post.dart';

abstract class BlogState {}

class BlogInitial extends BlogState {}

class BlogLoading extends BlogState {}

class BlogSuccess extends BlogState {
  final List<BlogPost> posts;

  BlogPost? get first => posts.isEmpty ? null : posts.first;

  BlogSuccess(this.posts);
}

class BlogError extends BlogState {
  final String message;

  BlogError(this.message);
}
