import 'package:reservation_workshop/modules/spare_parts/domain/entities/spare_product.dart';

abstract class ProductsState {
  const ProductsState();
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsSuccess extends ProductsState {
  final List<SpareProduct> products;

  const ProductsSuccess(this.products);
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);
}
