import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food/controllers/providers/providers.dart';
import 'package:food/view/pages/products_screen.dart';
import 'package:food/view/widgets/phone_auth_screen.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final user = ref.watch(authNotifierProvider);
    final authNotifier = ref.watch(authNotifierProvider.notifier);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Calories Products'),
          centerTitle: true,
          elevation: 5,
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, bottom: 25),
              child: ElevatedButton(
                onPressed: () async {
                  await authNotifier.signInWithGoogle();
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const ProductsPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .10,
                    ),
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: Colors.white,
                      child: Image.network(
                        'https://altogethergroup.com.au/static/img/google-g-logo.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .20,
                    ),
                    const Text(
                      'Google',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, bottom: 25),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => PhoneAuthScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .10,
                    ),
                    const Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .20,
                    ),
                    const Text(
                      'Phone',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}
