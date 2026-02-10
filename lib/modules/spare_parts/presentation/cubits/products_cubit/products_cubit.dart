import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/modules/spare_parts/data/datasources/products_remote_datasource.dart';

import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(const ProductsInitial());

  late final ProductsRemoteDataSource _remote = ProductsRemoteDataSource();

  Future<void> load({int perPage = -1}) async {
    emit(const ProductsLoading());
    try {
      final products = await _remote.getProducts(perPage: perPage);
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
