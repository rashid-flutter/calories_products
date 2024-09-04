import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food/controllers/providers/providers.dart';
import 'package:food/models/product_model.dart';

class CartPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final AsyncValue<Products> products = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
      ),
      body: products.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (products) {
          // Get the list of added dishes by filtering based on cartState
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
              : Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.green[800],
                      child: Text(
                        '${addedDishes.length} Dishes - $totalQuantity Items',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      dish.imageUrl != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                dish.imageUrl ?? '',
                                                width: 50.0,
                                                height: 50.0,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Icon(
                                                    Icons.broken_image,
                                                    size: 50.0,
                                                    color: Colors.grey,
                                                  );
                                                },
                                              ),
                                            )
                                          : const Icon(Icons.fastfood,
                                              size: 50.0),
                                      const SizedBox(width: 10.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dish.name ?? 'Dish',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'INR ${dish.price ?? 'N/A'}',
                                                  style: const TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '${dish.calories ?? 'N/A'} calories',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.remove_circle_outline),
                                            onPressed: () {
                                              ref
                                                  .read(cartProvider.notifier)
                                                  .updateQuantity(
                                                      dishId, quantity - 1);
                                            },
                                          ),
                                          Text(
                                            '$quantity',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.add_circle_outline),
                                            onPressed: () {
                                              ref
                                                  .read(cartProvider.notifier)
                                                  .updateQuantity(
                                                      dishId, quantity + 1);
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'INR ${(dish.price ?? 0) * quantity}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
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
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[800],
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
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
                );
        },
      ),
    );
  }
}