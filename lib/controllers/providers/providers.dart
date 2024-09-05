import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food/controllers/cart_notifier.dart';
import 'package:food/models/product_model.dart';
import 'package:food/services/product_service.dart';
import 'package:food/services/auth/auth_notifier.dart';

final cartProvider = StateNotifierProvider<CartNotifier, Map<String, int>>(
    (ref) => CartNotifier());

final productsProvider = FutureProvider<ProductModel>((ref) async {
  return ApiService().fetchProducts();
});
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier(ref.read(firebaseAuthProvider));
});
