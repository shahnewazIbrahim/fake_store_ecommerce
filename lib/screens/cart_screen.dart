import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  String money(num n) => n.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: Colors.teal[600],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: cart.cartItems.isEmpty
                ? const Center(child: Text('Your cart is empty'))
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: cart.cartItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = cart.cartItems[index];
                      final p = item.product;
                      final productId = p.id is int
                          ? p.id as int
                          : int.tryParse('${p.id}') ?? -1;

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
                              // Thumbnail
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  p.image ?? '',
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.image_not_supported),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Title + Unit price + Qty stepper
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.title ?? 'Untitled',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Unit: \$${money(item.unitPrice)}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    // Qty stepper
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.remove_circle_outline),
                                          onPressed: productId == -1
                                              ? null
                                              : () => cart.decrement(productId),
                                        ),
                                        Text(
                                          '${item.quantity}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.add_circle_outline),
                                          onPressed: productId == -1
                                              ? null
                                              : () => cart.increment(productId),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed: () =>
                                              cart.removeFromCart(p),
                                          icon:
                                              const Icon(Icons.delete_outline),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Line subtotal (price * qty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Subtotal',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '\$${money(item.lineTotal)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // ---- Footer Summary ----
          if (cart.cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Items: ${cart.totalItems}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        'Total: \$${money(cart.totalPrice)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 46,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.lock),
                      label: const Text(
                        'Proceed to Checkout',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        // TODO: implement checkout
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
