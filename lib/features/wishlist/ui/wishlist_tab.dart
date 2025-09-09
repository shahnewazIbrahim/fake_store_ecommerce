import 'package:fakestore_modern/widgets/product_card.dart';
import 'package:fakestore_modern/features/catalog/providers/cart_provider.dart';
import 'package:fakestore_modern/features/cart/models/product.dart';
import 'package:fakestore_modern/features/catalog/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistTab extends StatelessWidget {
  const WishlistTab({super.key});

  @override
  Widget build(BuildContext context) {
    final list = context.watch<WishlistProvider>().items;
    final cart = context.read<CartProvider>();

    if (list.isEmpty) {
      return const Center(child: Text('Your wishlist is empty'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 260,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (_, i) {
        final Product p = list[i];
        return ProductCard(
          product: p,
          onAddToCart: () => cart.add(p),
          showWishlistToggle: true,
        );
      },
    );
  }
}
