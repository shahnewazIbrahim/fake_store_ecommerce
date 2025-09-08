// import 'package:flutter/material.dart';
// import '../models/product.dart';
//
// class CartProvider with ChangeNotifier {
//   final List<Product> _cartItems = [];
//
//   List<Product> get cartItems => _cartItems;
//
//   void addToCart(Product product) {
//     _cartItems.add(product);
//     notifyListeners();
//   }
//
//   void removeFromCart(Product product) {
//     _cartItems.remove(product);
//     notifyListeners();
//   }
//
//   double get totalPrice =>
//       _cartItems.fold(0, (sum, item) => sum + item.price);
//
//   bool isInCart(Product product) {
//     return _cartItems.any((item) => item.id == product.id);
//   }
// }


import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/product.dart'; // <-- your Product model (id, title, image, price)

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get unitPrice => (product.price ?? 0).toDouble();
  double get lineTotal => unitPrice * quantity;
}

class CartProvider with ChangeNotifier {
  /// Keep items by productId (fast to update qty)
  final Map<int, CartItem> _items = {};

  /// Backward compatible getter you’re already using
  UnmodifiableListView<CartItem> get cartItems =>
      UnmodifiableListView(_items.values);

  double get totalPrice =>
      _items.values.fold(0.0, (sum, it) => sum + it.lineTotal);

  int get totalItems =>
      _items.values.fold(0, (sum, it) => sum + it.quantity);

  int quantityFor(int productId) => _items[productId]?.quantity ?? 0;

  void addToCart(Product p, {int qty = 1}) {
    final id = p.id is int ? p.id as int : int.tryParse('${p.id}') ?? -1;
    if (id == -1) return;

    if (_items.containsKey(id)) {
      _items[id]!.quantity += qty;
    } else {
      _items[id] = CartItem(product: p, quantity: qty);
    }
    notifyListeners();
  }

  void removeFromCart(Product p) {
    final id = p.id is int ? p.id as int : int.tryParse('${p.id}') ?? -1;
    if (id == -1) return;
    _items.remove(id);
    notifyListeners();
  }

  void increment(int productId) {
    final it = _items[productId];
    if (it == null) return;
    it.quantity += 1;
    notifyListeners();
  }

  void decrement(int productId) {
    final it = _items[productId];
    if (it == null) return;
    if (it.quantity > 1) {
      it.quantity -= 1;
    } else {
      _items.remove(productId); // qty 0 হলে আইটেম রিমুভ
    }
    notifyListeners();
  }

  void setQuantity(int productId, int qty) {
    final it = _items[productId];
    if (it == null) return;
    if (qty <= 0) {
      _items.remove(productId);
    } else {
      it.quantity = qty;
    }
    notifyListeners();
  }

  bool isInCart(Product product) {
    return _items.values.any((item) => item.product.id == product.id);
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
