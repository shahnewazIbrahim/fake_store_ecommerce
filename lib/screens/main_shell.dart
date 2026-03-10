import 'package:fake_store_ecommerce/screens/tabs/account_tab.dart';
import 'package:fake_store_ecommerce/screens/tabs/wishlist_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_bottom_nav.dart';
import 'tabs/home_tab.dart';
import 'tabs/cart_tab.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _titles = ['FakeStore', 'Your Cart', 'Wishlist', 'Account'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_index],
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: .2,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: _index == 1
            ? [] // Cart ট্যাবে কার্ট বাটন দেখানোর দরকার নেই
            : [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                  onPressed: () => setState(() => _index = 1),
                ),
              ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.primary.withOpacity(.95),
                const Color(0xFF0B5F59),
                const Color(0xFF0A3D3A),
              ],
            ),
          ),
        ),
      ),

      // body শুধু বদলাবে, state টিকে থাকবে
      body: IndexedStack(
        index: _index,
        children: const [
          HomeTab(), // 0
          CartTab(), // 1
          WishlistTab(), // 2
          AccountTab(), // 3
        ],
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String text;

  const _Placeholder(this.text);

  @override
  Widget build(BuildContext context) =>
      Center(child: Text(text, style: const TextStyle(fontSize: 16)));
}
