import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<int> {
  AppCubit() : super(0);

  static AppCubit get(context) => BlocProvider.of<AppCubit>(context);

  void changeCurrentIndex(int index) => emit(index);
}
