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

  void _safeEmit(CheckPhoneState state) {
    if (isClosed) return;
    try {
      emit(state);
    } on StateError {
      return;
    }
  }

  Future<void> checkPhone({required String mobile}) async {
    if (isClosed) return;
    _safeEmit(CheckPhoneLoading());

    final m = mobile.trim();
    if (m.isEmpty) {
      if (isClosed) return;
      _safeEmit(CheckPhoneError('Required'));
      return;
    }

    try {
      final result = await _usecase.call(mobile: m);
      if (isClosed) return;
      if (result.isSoftDeleted && (result.userId ?? 0) > 0) {
        _safeEmit(
          CheckPhoneRestoreRequired(
            userId: result.userId!,
            message: result.message.isNotEmpty ? result.message : 'Account has been deleted. Please restore it to continue.',
            mobile: m,
          ),
        );
        return;
      }
      _safeEmit(CheckPhoneSuccess(result: result, mobile: m));
    } catch (e) {
      if (isClosed) return;
      _safeEmit(CheckPhoneError(e.toString()));
    }
  }
}
