import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/modules/spare_parts/domain/entities/spare_cart_item.dart';
import 'package:reservation_workshop/modules/spare_parts/domain/entities/spare_product.dart';

import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartInitial());

  List<SpareCartItem> get _items {
    final s = state;
    if (s is CartUpdated) return s.items;
    return const <SpareCartItem>[];
  }

  void addProduct({
    required SpareProduct product,
    required int variationId,
    double? unitPrice,
  }) {
    final list = List<SpareCartItem>.from(_items);
    final idx = list.indexWhere((e) => e.product.id == product.id && e.variationId == variationId);
    if (idx == -1) {
      list.add(
        SpareCartItem(
          product: product,
          variationId: variationId,
          quantity: 1,
          unitPrice: unitPrice ?? product.defaultSellPrice,
          discountAmount: 0,
          discountType: 'fixed',
        ),
      );
    } else {
      final current = list[idx];
      list[idx] = current.copyWith(quantity: current.quantity + 1);
    }
    emit(CartUpdated(list));
  }

  void increment(SpareCartItem item) {
    final list = List<SpareCartItem>.from(_items);
    final idx = list.indexWhere((e) => e.product.id == item.product.id && e.variationId == item.variationId);
    if (idx == -1) return;
    final current = list[idx];
    list[idx] = current.copyWith(quantity: current.quantity + 1);
    emit(CartUpdated(list));
  }

  void decrement(SpareCartItem item) {
    final list = List<SpareCartItem>.from(_items);
    final idx = list.indexWhere((e) => e.product.id == item.product.id && e.variationId == item.variationId);
    if (idx == -1) return;
    final current = list[idx];
    final nextQty = current.quantity - 1;
    if (nextQty <= 0) {
      list.removeAt(idx);
    } else {
      list[idx] = current.copyWith(quantity: nextQty);
    }
    emit(CartUpdated(list));
  }

  void updateUnitPrice(SpareCartItem item, double unitPrice) {
    final list = List<SpareCartItem>.from(_items);
    final idx = list.indexWhere((e) => e.product.id == item.product.id && e.variationId == item.variationId);
    if (idx == -1) return;
    list[idx] = list[idx].copyWith(unitPrice: unitPrice);
    emit(CartUpdated(list));
  }

  void updateDiscount(SpareCartItem item, {required double amount, required String type}) {
    final list = List<SpareCartItem>.from(_items);
    final idx = list.indexWhere((e) => e.product.id == item.product.id && e.variationId == item.variationId);
    if (idx == -1) return;
    list[idx] = list[idx].copyWith(discountAmount: amount, discountType: type);
    emit(CartUpdated(list));
  }

  void clear() {
    emit(const CartUpdated(<SpareCartItem>[]));
  }
}
