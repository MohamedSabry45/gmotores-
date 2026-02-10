import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/blog_remote_datasource.dart';
import 'blog_state.dart';

class BlogCubit extends Cubit<BlogState> {
  BlogCubit() : super(BlogInitial());

  static BlogCubit get(context) => BlocProvider.of<BlogCubit>(context);

  late final BlogRemoteDataSource _remote = BlogRemoteDataSource();

  Future<void> loadFirst({String? localeCode}) async {
    emit(BlogLoading());
    try {
      final posts = await _remote.getBlogPosts(localeCode: localeCode);
      emit(BlogSuccess(posts));
    } catch (e) {
      emit(BlogError(e.toString()));
    }
  }
}
