import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food/controllers/providers/providers.dart';
import 'package:food/view/pages/products_screen.dart';
import 'package:food/view/widgets/phone_screen.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final user = ref.watch(authNotifierProvider);
    final authNotifier = ref.watch(authNotifierProvider.notifier);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign-In'),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () async {
                await authNotifier.signInWithGoogle();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => ProductsPage()));
              },
              child: const Text('Sign In with Google'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => PhoneAuthPage()));
              },
              child: const Text('Mobile Number'),
            ),
          ]),
        ));
  }
}
