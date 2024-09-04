import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends StateNotifier<Map<String, int>> {
  CartNotifier() : super({});

  // Method to update the quantity of an item in the cart
  void updateQuantity(String dishId, int quantity) {
    if (quantity <= 0) {
      state = {...state}..remove(dishId);
    } else {
      state = {...state, dishId: quantity};
    }
  }

  void clearCart() {
    state = {};
  }
}
