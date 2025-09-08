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
    final labels = ['Home', 'Shopping', 'Wishlist', 'Account'];
    final inactive = [
      CupertinoIcons.house,
      CupertinoIcons.bag,
      CupertinoIcons.heart,
      CupertinoIcons.person_crop_circle,
    ];
    final active = [
      CupertinoIcons.house_fill,
      CupertinoIcons.bag_fill,
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
                      gradient: selected
                          ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFF8A00), Color(0xFFFF5C00)],
                      )
                          : null,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: selected
                    // selected → capsule: icon + label (horizontal)
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 22, color: Colors.white),
                        const SizedBox(width: 8),
                        const SizedBox.shrink(),
                        Text(
                          labels[i],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                    // idle → small icon + label (vertical)
                        : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 22, color: hint),
                        const SizedBox(height: 4),
                        Text(
                          labels[i],
                          style: TextStyle(fontSize: 11, color: hint),
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
