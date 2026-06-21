import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';
import 'package:reservation_workshop/modules/menu/data/datasources/account_remote_datasource.dart';

import 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(DeleteAccountInitial());

  static DeleteAccountCubit get(context) => BlocProvider.of<DeleteAccountCubit>(context);

  final AccountRemoteDataSource _remote = AccountRemoteDataSource();

  Future<void> deleteAccount() async {
    emit(DeleteAccountLoading());
    try {
      await _remote.softDeleteAccount();

      AppConstants.token = null;
      await CacheHelper.saveData(key: PrefKeys.kAccessToken, value: '');

      emit(DeleteAccountSuccess());
    } catch (e) {
      emit(DeleteAccountError(e.toString()));
    }
  }
}
