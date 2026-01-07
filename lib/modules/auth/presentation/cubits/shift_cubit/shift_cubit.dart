import 'package:flutter_bloc/flutter_bloc.dart';

class ShiftCubit extends Cubit<int> {
  ShiftCubit() : super(0);

  static ShiftCubit get(context) => BlocProvider.of<ShiftCubit>(context);

  Future<void> getShiftStatus() async {}
}
