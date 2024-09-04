import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food/controllers/providers/providers.dart';
import 'package:food/models/product_model.dart';
import 'package:food/view/widgets/cart_screen.dart';
import 'package:food/view/widgets/profile_screen.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final AsyncValue<Products> products = ref.watch(productsProvider);

    return products.when(
      loading: () => Scaffold(
        appBar: AppBar(
          title: Text('Products'),
        ),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          title: Text('Products'),
        ),
        body: Center(child: Text('Error: $error')),
      ),
      data: (products) {
        final categories = products.categories ?? [];

        _tabController.dispose();
        _tabController = TabController(length: categories.length, vsync: this);

        return Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer
                },
              ),
            ),
            title: const Text('Products'),
            actions: [
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_cart),
                    cartState.values.isNotEmpty
                        ? Positioned(
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: Text(
                                '${cartState.values.reduce((a, b) => a + b)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Positioned(
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: const Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                  ],
                ),
                onPressed: () {
                  // Navigate to the cart page
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => CartPage()));
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.red,
              tabs: categories
                  .map((category) => Tab(text: category.name))
                  .toList(),
            ),
          ),
          drawer: const ProfileScreen(),
          body: TabBarView(
            controller: _tabController,
            children: categories.map((category) {
              return ListView.builder(
                itemCount: category.dishes?.length ?? 0,
                itemBuilder: (context, index) {
                  final dish = category.dishes![index];
                  final dishId =
                      dish.id.toString(); // Ensure dishId is a String
                  final dishQuantity = cartState[dishId] ?? 0;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              dish.imageUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        dish.imageUrl ?? '',
                                        width: 50.0,
                                        height: 50.0,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.broken_image,
                                            size: 50.0,
                                            color: Colors.grey,
                                          );
                                        },
                                      ),
                                    )
                                  : const Icon(Icons.fastfood, size: 50.0),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'SAR ${dish.price ?? 'N/A'}',
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
                                    const SizedBox(height: 4.0),
                                    Text(
                                      dish.description ??
                                          'No description available',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          if (dish.customizationsAvailable ?? false)
                            const Text(
                              'Customizations Available',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12.0,
                              ),
                            ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .updateQuantity(dishId, dishQuantity - 1);
                                },
                              ),
                              Text(
                                '$dishQuantity',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .updateQuantity(dishId, dishQuantity + 1);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
