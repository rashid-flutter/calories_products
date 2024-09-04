import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food/controllers/providers/providers.dart';
import 'package:food/view/widgets/auth_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(user?.photoURL ?? ''),
            child: user?.photoURL == null
                ? const Icon(Icons.person, size: 40)
                : null,
          ),
          const SizedBox(height: 10),
          Text(
            user?.displayName ?? 'Guest',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'ID: ${user?.uid ?? 'N/A'}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () {
              ref.read(authNotifierProvider.notifier).signOut();
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                  (r) => false);
            },
          ),
        ],
      ),
    );
  }
}
