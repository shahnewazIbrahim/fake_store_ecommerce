import 'package:fakestore_modern/features/cart/models/product.dart';
import 'package:flutter/foundation.dart';

class WishlistProvider extends ChangeNotifier {
  final Map<int, Product> _map = {};
  List<Product> get items => _map.values.toList();
  bool contains(int id) => _map.containsKey(id);

  void toggle(Product p) {
    if (_map.containsKey(p.id))
      _map.remove(p.id);
    else
      _map[p.id] = p;
    notifyListeners();
  }
}
