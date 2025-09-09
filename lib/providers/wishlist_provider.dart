import 'package:fakestore_modern/features/cart/models/product.dart';
import 'package:flutter/material.dart';

class WishlistProvider with ChangeNotifier {
  final List<Product> _wishlist = [];

  List<Product> get wishlist => _wishlist;

  void toggleWishlist(Product product) {
    final exists = _wishlist.any((item) => item.id == product.id);
    if (exists) {
      _wishlist.removeWhere((item) => item.id == product.id);
    } else {
      _wishlist.add(product);
    }
    notifyListeners();
  }

  bool isInWishlist(Product product) {
    return _wishlist.any((item) => item.id == product.id);
  }
}
