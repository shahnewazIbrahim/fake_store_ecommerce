// lib/widgets/home_banners.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/banner_item.dart';
import '../services/api_service.dart';

class HomeBanners extends StatefulWidget {
  const HomeBanners({super.key});
  @override
  State<HomeBanners> createState() => _HomeBannersState();
}

class _HomeBannersState extends State<HomeBanners> {
  final _pc = PageController(viewportFraction: 0.92);
  int _index = 0;
  Timer? _timer;
  late Future<List<BannerItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchBanners(limit: 6);
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      final next = _index + 1;
      _pc.animateToPage(
        next,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: FutureBuilder<List<BannerItem>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return _loadingSkeleton();
          }
          if (snap.hasError) {
            return _errorBox(snap.error.toString());
          }
          final items = snap.data ?? const <BannerItem>[];
          if (items.isEmpty) {
            return _errorBox('No banners found');
          }

          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                controller: _pc,
                onPageChanged: (i) {
                  setState(() => _index = i % items.length);
                  // ইন্ডেক্স লুপ করে রাখি
                  if (i >= items.length * 1000) {
                    _pc.jumpToPage(_index);
                  }
                },
                itemBuilder: (_, i) {
                  final item = items[i % items.length];
                  return _BannerCard(item: item);
                },
              ),
              Positioned(
                bottom: 10,
                child: Row(
                  children: List.generate(items.length, (i) {
                    final active = i == _index % items.length;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: active ? 16 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active
                            ? Colors.white
                            : Colors.white.withOpacity(.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _loadingSkeleton() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemBuilder: (_, __) => Container(
        width: MediaQuery.of(context).size.width * 0.86,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemCount: 2,
    );
  }

  Widget _errorBox(String msg) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.red.shade50,
      ),
      alignment: Alignment.center,
      child: Text(msg, style: TextStyle(color: Colors.red.shade700)),
    );
  }
}

class _BannerCard extends StatelessWidget {
  final BannerItem item;
  const _BannerCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        onTap: () {
          // TODO: প্রোডাক্ট ডিটেইলস-এ যাও
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Open product #${item.productId} (TODO)')),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ই-কমার্স প্রোডাক্ট ফটো (FakeStore থেকে)
              Image.network(
                item.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey.shade200),
              ),
              // গ্রেডিয়েন্ট ওভারলে + টেক্সট
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
              ),
              Positioned(
                left: 14,
                bottom: 14,
                right: 60,
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    shadows: [Shadow(blurRadius: 6, color: Colors.black45)],
                  ),
                ),
              ),
              // কোণায় ছোট ব্যাজ (ঐচ্ছিক)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Hot',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
