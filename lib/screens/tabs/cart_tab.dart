import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class CartTab extends StatelessWidget {
  const CartTab({super.key});
  String money(num n) => n.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      children: [
        const SizedBox(height: 8),
        Expanded(
          child: cart.cartItems.isEmpty
              ? Center(
                  child: Text(
                    'Your cart is empty',
                    style: theme.textTheme.titleMedium,
                  ),
                )
              : ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: cart.cartItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = cart.cartItems[index];
              final p = item.product;
              final productId = p.id is int ? p.id as int : int.tryParse('${p.id}') ?? -1;

              return Card(
                elevation: 0,
                color: scheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: scheme.outline.withOpacity(.7)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            p.image ?? '',
                            width: 64, height: 64, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.title ?? 'Untitled',
                              maxLines: 2, overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text('Unit: \$${money(item.unitPrice)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurface.withOpacity(.65),
                                )),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: productId == -1 ? null : () => cart.decrement(productId),
                                ),
                                Text('${item.quantity}',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: productId == -1 ? null : () => cart.increment(productId),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () => cart.removeFromCart(p),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Subtotal',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: scheme.onSurface.withOpacity(.6),
                              )),
                          Text('\$${money(item.lineTotal)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (cart.cartItems.isNotEmpty)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: scheme.surface,
              border: Border(top: BorderSide(color: scheme.outline.withOpacity(.7))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Items: ${cart.totalItems}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    Text('Total: \$${money(cart.totalPrice)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        )),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary, foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.lock),
                    label: const Text('Proceed to Checkout',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    onPressed: () {/* TODO: checkout */},
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
