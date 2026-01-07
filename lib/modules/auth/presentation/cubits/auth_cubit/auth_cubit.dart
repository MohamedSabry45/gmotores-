import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of<AuthCubit>(context);

  Future<void> loginUser({required String userName, required String password}) async {
    emit(LoginLoadingState());
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (userName.trim().isEmpty || password.trim().isEmpty) {
      emit(LoginErrorState('Invalid credentials'));
      return;
    }
    emit(LoginSuccessState());
  }

  Future<void> getLoggedinUser() async {}

  Future<void> getUserBusinessLocation() async {}
}
