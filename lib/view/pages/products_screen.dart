import 'package:cached_network_image/cached_network_image.dart';
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
    final AsyncValue<ProductModel> products = ref.watch(productsProvider);

    return products.when(
      loading: () => Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
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
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer
                },
              ),
            ),
            elevation: 5,
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CartScreen()));
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
          drawer: const ProfileScreen(), // Replace with MyDrawer() if needed
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
                              const SizedBox(width: 10.0),

                              // Display dish name in colored circle
                              dish.customizationsAvailable ?? false
                                  ? Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.5, color: Colors.green)),
                                      child: Center(
                                        child: Container(
                                          width: 13,
                                          height: 13,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.5, color: Colors.red)),
                                      child: Center(
                                        child: Container(
                                          width: 13,
                                          height: 13,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                        ),
                                      ),
                                    ),

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
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${dish.calories ?? 'N/A'} calories',
                                          style: const TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold),
                                        ),
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
                                                    return CachedNetworkImage(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        fit: BoxFit.cover,
                                                        imageUrl:
                                                            'https://hdwallpaperim.com/wp-content/uploads/2017/08/31/155931-food.jpg');
                                                  },
                                                ),
                                              )
                                            : const Icon(Icons.fastfood,
                                                size: 50.0),
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
                          Container(
                            width: MediaQuery.of(context).size.width * .30,
                            height: MediaQuery.of(context).size.width * .10,
                            decoration: BoxDecoration(
                                color: Colors.green[800],
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(cartProvider.notifier)
                                          .updateQuantity(
                                              dishId, dishQuantity - 1);
                                    },
                                  ),
                                  Text(
                                    '$dishQuantity',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(cartProvider.notifier)
                                          .updateQuantity(
                                              dishId, dishQuantity + 1);
                                    },
                                  ),
                                ],
                              ),
                            ),
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
