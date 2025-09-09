import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/utils/money.dart';
import 'package:fakestore_modern/features/catalog/providers/cart_provider.dart';
import 'package:fakestore_modern/features/cart/models/product.dart';
import 'package:fakestore_modern/features/catalog/providers/wishlist_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onAddToCart;
  final bool showWishlistToggle;
  const ProductCard({
    super.key,
    required this.product,
    this.onAddToCart,
    this.showWishlistToggle = true,
  });

  @override
  Widget build(BuildContext context) {
    final wish = context.watch<WishlistProvider>();
    final isFav = wish.contains(product.id);

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Icon(Icons.image_not_supported)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text("\$${money(product.price)}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: onAddToCart ??
                                () => context.read<CartProvider>().add(product),
                            child: const Text('Add'),
                          ),
                        ),
                        if (showWishlistToggle) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => context
                                .read<WishlistProvider>()
                                .toggle(product),
                            icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
