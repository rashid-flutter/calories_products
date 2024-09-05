import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food/controllers/providers/providers.dart';

class PhoneAuthScreen extends ConsumerWidget {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  PhoneAuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    // final user = ref.watch(authNotifierProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Phone Number Sign-In'),
          elevation: 5,
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: 'Phone Number'),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .10,
                  ),
                  if (authNotifier.verificationId == null) ...[
                    ElevatedButton(
                      onPressed: () async {
                        await authNotifier.signInWithPhoneNumber(
                          _phoneController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        // padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Send Code',
                        style: TextStyle(color: Colors.white),
                      ),
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
            ),
          ]),
        ));
  }
}
