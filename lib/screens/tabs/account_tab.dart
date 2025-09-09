import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  // TODO: পরবর্তীতে AuthProvider/Bloc যুক্ত করে এটাকে derive করবেন
  bool isLoggedIn = false;
  bool pushNotifs = true;

  String _appVersion = ''; // e.g. "1.2.3+45"

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      // version = pubspec এর 1.2.3, buildNumber = +45 অংশ
      final v = info.version;
      final b = info.buildNumber;
      setState(() {
        _appVersion = b.isNotEmpty ? '$v+$b' : v;
      });
      debugPrint('version ${_appVersion}');
    } catch (_) {
      _appVersion = ''; // fallback/ignore
    }
  }

  void _showLoginSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => const _LoginSheet(),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      child: Column(
        children: [
          // ---------- Header Card ----------
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.teal.shade800,
                  Colors.teal.shade600,
                  Colors.teal.shade400,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white70, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
                    // না থাকলে একটা ডিফল্ট কালার রাউন্ড দেখাবে
                    onBackgroundImageError: (_, __) {},
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: isLoggedIn
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Hello, John Doe',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(height: 4),
                            Text('johndoe@example.com',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                )),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Welcome, Guest',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(height: 4),
                            Text('Log in to see your orders, wishlist & more',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                )),
                          ],
                        ),
                ),
                const SizedBox(width: 8),
                if (!isLoggedIn)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal.shade700,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _showLoginSheet,
                    child: const Text(
                      'Log in',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  )
                else
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      setState(() => isLoggedIn = false);
                      _showSnack('Signed out (TODO: wire up actual auth)');
                    },
                    child: const Text('Sign out'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ---------- Account section ----------
          _SectionCard(
            title: 'My Account',
            children: [
              _Tile(
                icon: Icons.person_outline,
                label: 'Profile',
                onTap: () => _showSnack('Profile (TODO)'),
              ),
              _Tile(
                icon: Icons.receipt_long_outlined,
                label: 'Orders',
                onTap: () => _showSnack('Orders (TODO)'),
              ),
              _Tile(
                icon: Icons.favorite_border,
                label: 'Wishlist',
                onTap: () => _showSnack('Wishlist (switch to tab)'),
              ),
              _Tile(
                icon: Icons.location_on_outlined,
                label: 'Addresses',
                onTap: () => _showSnack('Addresses (TODO)'),
              ),
              _Tile(
                icon: Icons.credit_card,
                label: 'Payment methods',
                onTap: () => _showSnack('Payment methods (TODO)'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ---------- Preferences section ----------
          _SectionCard(
            title: 'Preferences',
            children: [
              SwitchListTile.adaptive(
                value: pushNotifs,
                onChanged: (v) => setState(() => pushNotifs = v),
                title: const Text('Push notifications'),
                secondary:
                    const _IconBubble(icon: Icons.notifications_outlined),
              ),
              _Tile(
                icon: Icons.translate,
                label: 'Language',
                trailing:
                    const Text('English', style: TextStyle(color: Colors.grey)),
                onTap: () => _showSnack('Language picker (TODO)'),
              ),
              _Tile(
                icon: Icons.dark_mode_outlined,
                label: 'Theme',
                trailing:
                    const Text('System', style: TextStyle(color: Colors.grey)),
                onTap: () => _showSnack('Theme chooser (TODO)'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ---------- Support & Legal ----------
          _SectionCard(
            title: 'Support',
            children: [
              _Tile(
                icon: Icons.help_outline,
                label: 'Help Center',
                onTap: () => _showSnack('Help Center (TODO)'),
              ),
              _Tile(
                icon: Icons.chat_bubble_outline,
                label: 'Contact us',
                onTap: () => _showSnack('Contact form (TODO)'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _SectionCard(
            title: 'About',
            children: [
              const _TileStatic(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy Policy',
                trailing: Icon(Icons.open_in_new, size: 18),
              ),
              const _TileStatic(
                icon: Icons.description_outlined,
                label: 'Terms & Conditions',
                trailing: Icon(Icons.open_in_new, size: 18),
              ),
              _TileStatic(
                icon: Icons.info_outline,
                label: 'App version',
                // trailing: Text('v1.0.0', style: TextStyle(color: Colors.grey)),
                trailing: Text(
                  _appVersion.isEmpty ? '...' : 'v$_appVersion',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -------------------- Widgets --------------------

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = BorderSide(color: theme.dividerColor.withOpacity(.2));

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.fromBorderSide(border),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ..._withDividers(children),
        ],
      ),
    );
  }

  List<Widget> _withDividers(List<Widget> tiles) {
    final out = <Widget>[];
    for (var i = 0; i < tiles.length; i++) {
      out.add(tiles[i]);
      if (i != tiles.length - 1) {
        out.add(const Divider(height: 1));
      }
    }
    return out;
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _Tile({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: _IconBubble(icon: icon),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _TileStatic extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;

  const _TileStatic({
    required this.icon,
    required this.label,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _IconBubble(icon: icon),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: trailing ?? const SizedBox.shrink(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  final IconData icon;

  const _IconBubble({required this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = scheme.primary.withOpacity(.12);
    final fg = scheme.primary;

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: fg),
    );
  }
}

// -------------------- Login Bottom Sheet (UI only) --------------------

class _LoginSheet extends StatefulWidget {
  const _LoginSheet();

  @override
  State<_LoginSheet> createState() => _LoginSheetState();
}

class _LoginSheetState extends State<_LoginSheet> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _busy = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    await Future.delayed(const Duration(milliseconds: 600)); // demo feel

    // TODO: এখানে API কল করবেন (AuthProvider/Repository)
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('TODO: Wire up login API')),
      );
    }
    setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).viewInsets;

    return Padding(
      padding: EdgeInsets.only(bottom: insets.bottom),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Log in',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email or phone',
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.length < 4) ? 'Min 4 chars' : null,
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Forgot password (TODO)')),
                      ),
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _busy ? null : _submit,
                      icon: _busy
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.login),
                      label: const Text(
                        'Continue',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('New here?',
                          style: TextStyle(color: Colors.grey.shade700)),
                      TextButton(
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text('Sign up (TODO)'))),
                        child: const Text('Create an account'),
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
  }
}
