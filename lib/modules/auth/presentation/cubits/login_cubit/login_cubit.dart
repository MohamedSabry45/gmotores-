import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

import '../../../data/datasources/auth_remote_datasource.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of<LoginCubit>(context);

  late final LoginUsecase _usecase = LoginUsecase(
    AuthRepositoryImpl(AuthRemoteDataSource()),
  );

  Future<void> login({required String mobile, required String password}) async {
    emit(LoginLoading());

    final m = mobile.trim();
    final p = password.trim();

    if (m.isEmpty || p.isEmpty) {
      emit(LoginError('Required'));
      return;
    }

    try {
      final session = await _usecase.call(mobile: m, password: p);
      if (session.token.trim().isNotEmpty) {
        AppConstants.token = session.token;
        await CacheHelper.saveData(key: PrefKeys.kAccessToken, value: session.token);
      }
      emit(LoginSuccess(session));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
