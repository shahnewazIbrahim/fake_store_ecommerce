import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';

class WishlistTab extends StatelessWidget {
  const WishlistTab({super.key});

  String money(num n) => n.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final wish = Provider.of<WishlistProvider>(context);

    // আপনার প্রোভাইডারে যেটা আছে সেটি ব্যবহার করুন:
    final List<Product> items = wish.wishlist;

    return Column(
      children: [
        const SizedBox(height: 8),
        Expanded(
          child: items.isEmpty
              ? const _EmptyState()
              : ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final p = items[index];
              final inCart = cart.isInCart(p);

              return Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          p.image,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '\$${money(p.price)}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                // Add to cart
                                SizedBox(
                                  height: 38,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: inCart
                                          ? Colors.grey
                                          : Colors.teal[600],
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                    ),
                                    icon: Icon(
                                      inCart
                                          ? Icons.check
                                          : Icons.add_shopping_cart,
                                      size: 18,
                                    ),
                                    label: Text(
                                      inCart ? 'In Cart' : 'Add to Cart',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: inCart
                                        ? null
                                        : () {
                                      cart.addToCart(p);
                                      // উইশলিস্ট থেকেও সরাতে চাইলে:
                                      // wish.toggleWishlist(p);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Added to cart'),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Remove
                                IconButton(
                                  tooltip: 'Remove from wishlist',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () {
                                    wish.toggleWishlist(p);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Removed from wishlist'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Bottom summary/actions
        if (items.isNotEmpty)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Items: ${items.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.teal[700],
                          side: BorderSide(color: Colors.teal.shade700),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size.fromHeight(46),
                        ),
                        icon: const Icon(Icons.clear_all),
                        label: const Text(
                          'Clear wishlist',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          // যদি wish.clear() থাকে, সরাসরি কল করুন:
                          // wish.clear();
                          final copy = List<Product>.from(items);
                          for (final p in copy) {
                            wish.toggleWishlist(p);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Wishlist cleared'),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size.fromHeight(46),
                        ),
                        icon: const Icon(Icons.shopping_bag),
                        label: const Text(
                          'Move all to cart',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          final toMove = List<Product>.from(items);
                          int moved = 0;
                          for (final p in toMove) {
                            if (!cart.isInCart(p)) {
                              cart.addToCart(p);
                            }
                            // উইশলিস্ট থেকে সরাই
                            wish.toggleWishlist(p);
                            moved++;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Moved $moved item(s) to cart'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border,
              size: 56, color: Colors.grey.shade500),
          const SizedBox(height: 8),
          Text(
            'Your wishlist is empty',
            style:
            TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
