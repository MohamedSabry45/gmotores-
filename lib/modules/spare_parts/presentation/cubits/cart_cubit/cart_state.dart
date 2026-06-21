import 'package:reservation_workshop/modules/spare_parts/domain/entities/spare_cart_item.dart';

abstract class CartState {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartUpdated extends CartState {
  final List<SpareCartItem> items;

  const CartUpdated(this.items);

  int get totalQuantity {
    var sum = 0;
    for (final i in items) {
      sum += i.quantity;
    }
    return sum;
  }

  double get subtotal {
    var sum = 0.0;
    for (final i in items) {
      sum += (i.unitPrice * i.quantity);
    }
    return sum;
  }

  double get total {
    var sum = 0.0;
    for (final i in items) {
      sum += i.lineTotal;
    }
    return sum;
  }
}
