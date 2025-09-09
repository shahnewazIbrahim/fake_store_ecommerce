import 'package:fakestore_modern/features/auth/providers/auth_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class AccountTab extends StatelessWidget {
  const AccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProviderCustom>();
    if (!auth.enabled) {
      return const Center(
        child: Text(
          'Auth disabled (Firebase not configured).\nRun `flutterfire configure` to enable.',
          textAlign: TextAlign.center,
        ),
      );
    }

    final fb.User? u = auth.user;
    if (u == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You are not logged in'),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () => context.read<AuthProviderCustom>().signInAnon(),
              child: const Text('Continue as Guest'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Signed in as', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(u.isAnonymous ? 'Guest User' : (u.email ?? u.uid),
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => context.read  < AuthProviderCustom > ().signOut(),
            icon: const Icon(Icons.logout),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
