import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

import '../../../data/datasources/customer_remote_datasource.dart';
import '../../../data/repositories/customer_repository_impl.dart';
import '../../../domain/usecases/get_customer_info_usecase.dart';
import '../../../domain/entities/customer_info.dart';
import 'customer_info_state.dart';

class CustomerInfoCubit extends Cubit<CustomerInfoState> {
  CustomerInfoCubit() : super(CustomerInfoInitial());

  static CustomerInfoCubit get(context) => BlocProvider.of<CustomerInfoCubit>(context);

  late final GetCustomerInfoUsecase _usecase = GetCustomerInfoUsecase(
    CustomerRepositoryImpl(CustomerRemoteDataSource()),
  );
 
  Future<bool> _isGuestMode() async {
    return await CacheHelper.getDataAsync<bool>(key: PrefKeys.kIsGuestMode) ?? false;
  }

  void _safeEmit(CustomerInfoState state) {
    if (isClosed) return;
    try {
      emit(state);
    } on StateError {
      return;
    }
  }

  Future<void> load() async {
    if (isClosed) return;
    _safeEmit(CustomerInfoLoading());
    try {
      if (await _isGuestMode()) {
        final guestInfo = CustomerInfo(
          id: 0,
          name: '',
          mobile: '',
          cars: const [],
        );
        _safeEmit(CustomerInfoSuccess(guestInfo));
        return;
      }
      final info = await _usecase.call();
      if (isClosed) return;
      _safeEmit(CustomerInfoSuccess(info));
    } catch (e) {
      if (isClosed) return;
      _safeEmit(CustomerInfoError(e.toString()));
    }
  }
}
