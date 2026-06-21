import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/auth_remote_datasource.dart';

class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String mobile;

  ForgotPasswordSuccess(this.mobile);
}

class ForgotPasswordError extends ForgotPasswordState {
  final String message;

  ForgotPasswordError(this.message);
}

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  static ForgotPasswordCubit get(context) =>
      BlocProvider.of<ForgotPasswordCubit>(context);

  final AuthRemoteDataSource _remote = AuthRemoteDataSource();

  Future<void> forgotPassword({required String mobile}) async {
    if (isClosed) return;
    emit(ForgotPasswordLoading());

    final m = mobile.trim();
    if (m.isEmpty) {
      if (isClosed) return;
      emit(ForgotPasswordError('Mobile number is required'));
      return;
    }

    try {
      await _remote.forgotPassword(mobile: m);
      if (isClosed) return;
      emit(ForgotPasswordSuccess(m));
    } catch (e) {
      if (isClosed) return;
      emit(ForgotPasswordError(e.toString()));
    }
  }
}
