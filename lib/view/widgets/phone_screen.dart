import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food/controllers/providers/providers.dart';

class PhoneAuthPage extends ConsumerWidget {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  PhoneAuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    // final user = ref.watch(authNotifierProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Phone Number Sign-In'),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                if (authNotifier.verificationId == null) ...[
                  ElevatedButton(
                    onPressed: () async {
                      await authNotifier.signInWithPhoneNumber(
                        _phoneController.text,
                      );
                    },
                    child: const Text('Send Code'),
                  ),
                ] else ...[
                  TextField(
                    controller: _codeController,
                    decoration: const InputDecoration(labelText: 'SMS Code'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await authNotifier.signInWithSmsCode(
                        _codeController.text,
                      );
                    },
                    child: const Text('Verify Code'),
                  ),
                ],
              ],
            ),
          ]),
        ));
  }
}
