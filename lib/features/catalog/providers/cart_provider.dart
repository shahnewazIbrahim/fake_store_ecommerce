import 'package:fakestore_modern/features/cart/models/product.dart';
import 'package:flutter/foundation.dart';

import 'package:fakestore_modern/features/cart/models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _map = {};

  List<CartItem> get cartItems => _map.values.toList();
  int get totalItems => _map.values.fold(0, (s, v) => s + v.quantity);
  double get totalPrice => _map.values.fold(0.0, (s, v) => s + v.lineTotal);

  void add(Product p) {
    final ex = _map[p.id];
    if (ex == null) {
      _map[p.id] = CartItem(product: p, quantity: 1);
    } else {
      ex.quantity += 1;
    }
    notifyListeners();
  }

  void increment(int productId) {
    final ex = _map[productId];
    if (ex == null) return;
    ex.quantity += 1;
    notifyListeners();
  }

  void decrement(int productId) {
    final ex = _map[productId];
    if (ex == null) return;
    ex.quantity -= 1;
    if (ex.quantity <= 0) _map.remove(productId);
    notifyListeners();
  }

  void remove(Product p) {
    _map.remove(p.id);
    notifyListeners();
  }

  void clear() {
    _map.clear();
    notifyListeners();
  }
}
