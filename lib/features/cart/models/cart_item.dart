import 'package:fakestore_modern/features/cart/models/product.dart';


class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});

  double get unitPrice => product.price;
  double get lineTotal => unitPrice * quantity;
}
