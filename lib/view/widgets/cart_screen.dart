import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food/controllers/providers/providers.dart';
import 'package:food/models/product_model.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final AsyncValue<ProductModel> products = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        elevation: 5,
      ),
      body: products.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (products) {
          final addedDishes = products.categories!
              .expand((category) => category.dishes ?? [])
              .where((dish) => cartState.containsKey(dish.id.toString()))
              .toList();

          final totalQuantity = cartState.values.isNotEmpty
              ? cartState.values.reduce((a, b) => a + b)
              : 0;
          final totalAmount = addedDishes.fold<double>(
            0.0,
            (sum, dish) {
              final price = double.tryParse(dish.price ?? '0') ?? 0.0;
              final quantity = cartState[dish.id.toString()] ?? 0;
              return sum + price * quantity;
            },
          );

          return addedDishes.isEmpty
              ? const Center(child: Text('Your cart is empty'))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            color: Colors.green[800],
                            borderRadius: BorderRadius.circular(6)),
                        child: Center(
                          child: Text(
                            '${addedDishes.length} Dishes - $totalQuantity Items',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: addedDishes.length,
                          itemBuilder: (context, index) {
                            final dish = addedDishes[index];
                            final dishId = dish.id.toString();
                            final quantity = cartState[dishId] ?? 0;

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.5,
                                              color:
                                                  dish.customizationsAvailable ??
                                                          false
                                                      ? Colors.green
                                                      : Colors.red)),
                                      child: Center(
                                        child: Container(
                                          width: 13,
                                          height: 13,
                                          decoration: BoxDecoration(
                                              color:
                                                  dish.customizationsAvailable ??
                                                          false
                                                      ? Colors.green
                                                      : Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  dish.name ?? 'Dish',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .30,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .10,
                                                decoration: BoxDecoration(
                                                    color: Colors.green[800],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.remove,
                                                          color: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          ref
                                                              .read(cartProvider
                                                                  .notifier)
                                                              .updateQuantity(
                                                                  dishId,
                                                                  quantity - 1);
                                                        },
                                                      ),
                                                      Text(
                                                        '$quantity',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          ref
                                                              .read(cartProvider
                                                                  .notifier)
                                                              .updateQuantity(
                                                                  dishId,
                                                                  quantity + 1);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8.0),
                                              Expanded(
                                                child: Text(
                                                  'INR ${dish.price}',
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4.0),
                                          Row(
                                            children: [
                                              Text(
                                                'INR ${(double.tryParse(dish.price ?? '0') ?? 0) * quantity}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                          Text(
                                            '${dish.calories ?? 'N/A'} calories',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Amount',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  'INR $totalAmount',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () async {
                                // Handle order placement
                                await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title:
                                        const Text('Order successfully placed'),
                                    content: const Text(
                                        'Your order has been placed successfully.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );

                                // Clear the cart
                                ref.read(cartProvider.notifier).clearCart();

                                // Navigate to the homepage
                                // ignore: use_build_context_synchronously
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[800],
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Place Order',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
