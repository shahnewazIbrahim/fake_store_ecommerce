import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Shopping → Cart
    final labels = ['Home', 'Cart', 'Wishlist', 'Account'];
    final inactive = [
      CupertinoIcons.house,
      CupertinoIcons.cart, // ← cart
      CupertinoIcons.heart,
      CupertinoIcons.person_crop_circle,
    ];
    final active = [
      CupertinoIcons.house_fill,
      CupertinoIcons.cart_fill, // ← cart_fill
      CupertinoIcons.heart_fill,
      CupertinoIcons.person_crop_circle_fill,
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              if (!isDark)
                const BoxShadow(
                  blurRadius: 16,
                  offset: Offset(0, 8),
                  color: Color(0x1A000000),
                ),
            ],
          ),
          child: Row(
            children: List.generate(labels.length, (i) {
              final selected = i == currentIndex;
              final icon = selected ? active[i] : inactive[i];
              final hint = Theme.of(context).hintColor;

              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onTap(i);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    padding: EdgeInsets.symmetric(
                      horizontal: selected ? 14 : 0,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      // ✅ আপনার teal gradient
                      gradient: selected
                          ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF00695C),
                          Color(0xFF00897B),
                          Color(0xFF26A69A),
                        ],
                      )
                          : null,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    // ✅ selected অবস্থায়ও vertical icon+label (আপনার মতো)
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          size: selected ? 18 : 22, // আপনার সেটিং
                          color: selected ? Colors.white : hint,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          labels[i],
                          style: TextStyle(
                            fontSize: selected ? 12 : 11, // আপনার সেটিং
                            fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                            color: selected ? Colors.white : hint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
