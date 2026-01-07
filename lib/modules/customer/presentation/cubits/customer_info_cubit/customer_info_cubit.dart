import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/customer_remote_datasource.dart';
import '../../../data/repositories/customer_repository_impl.dart';
import '../../../domain/usecases/get_customer_info_usecase.dart';
import 'customer_info_state.dart';

class CustomerInfoCubit extends Cubit<CustomerInfoState> {
  CustomerInfoCubit() : super(CustomerInfoInitial());

  static CustomerInfoCubit get(context) => BlocProvider.of<CustomerInfoCubit>(context);

  late final GetCustomerInfoUsecase _usecase = GetCustomerInfoUsecase(
    CustomerRepositoryImpl(CustomerRemoteDataSource()),
  );

  Future<void> load() async {
    emit(CustomerInfoLoading());
    try {
      final info = await _usecase.call();
      emit(CustomerInfoSuccess(info));
    } catch (e) {
      emit(CustomerInfoError(e.toString()));
    }
  }
}
