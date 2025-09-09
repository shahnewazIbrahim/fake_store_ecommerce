import 'package:fakestore_modern/features/cart/models/product.dart';
import 'package:flutter/foundation.dart';

import '../services/product_api.dart';

class ProductProvider extends ChangeNotifier {
  final ProductSource _source;
  ProductProvider({ProductSource? source})
      : _source = source ?? MockProductApi();

  List<Product> _all = [];
  List<Product> _filtered = [];
  String _selectedCategory = 'All';
  bool _loading = false;

  List<Product> get products => _filtered;
  List<String> get categories {
    final cats = {'All', ..._all.map((p) => p.category)}.toList()..sort();
    return cats;
  }

  String get selectedCategory => _selectedCategory;
  bool get loading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    try {
      _all = await _source.fetchProducts();
      _applyFilter();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void filterByCategory(String cat) {
    _selectedCategory = cat;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    _filtered = _selectedCategory == 'All'
        ? List.from(_all)
        : _all.where((p) => p.category == _selectedCategory).toList();
  }
}
