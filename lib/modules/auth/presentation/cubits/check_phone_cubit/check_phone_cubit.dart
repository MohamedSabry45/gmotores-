import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/auth_remote_datasource.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../domain/usecases/check_phone_usecase.dart';
import 'check_phone_state.dart';

class CheckPhoneCubit extends Cubit<CheckPhoneState> {
  CheckPhoneCubit() : super(CheckPhoneInitial());

  static CheckPhoneCubit get(context) => BlocProvider.of<CheckPhoneCubit>(context);

  late final CheckPhoneUsecase _usecase = CheckPhoneUsecase(
    AuthRepositoryImpl(AuthRemoteDataSource()),
  );

  Future<void> checkPhone({required String mobile}) async {
    emit(CheckPhoneLoading());

    final m = mobile.trim();
    if (m.isEmpty) {
      emit(CheckPhoneError('Required'));
      return;
    }

    try {
      final result = await _usecase.call(mobile: m);
      emit(CheckPhoneSuccess(result: result, mobile: m));
    } catch (e) {
      emit(CheckPhoneError(e.toString()));
    }
  }
}
