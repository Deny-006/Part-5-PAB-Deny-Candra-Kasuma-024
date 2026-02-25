import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/cart_model.dart';
import 'cart_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String selectedCategory = 'All';
  String searchQuery = '';

  final List<Map<String, dynamic>> products = [
    {
      "product": Product(
        id: '1',
        name: 'Gaming Keyboard RGB',
        price: 850000,
        emoji: '⌨️',
        description: 'Mechanical keyboard RGB',
      ),
      "category": "Accessories",
    },
    {
      "product": Product(
        id: '2',
        name: 'Gaming Mouse Pro',
        price: 650000,
        emoji: '🖱️',
        description: 'Mouse gaming presisi tinggi',
      ),
      "category": "Accessories",
    },
    {
      "product": Product(
        id: '3',
        name: 'Gaming Chair',
        price: 2500000,
        emoji: '🪑',
        description: 'Kursi gaming ergonomis',
      ),
      "category": "Furniture",
    },
    {
      "product": Product(
        id: '4',
        name: 'Ultra Wide Monitor',
        price: 4500000,
        emoji: '🖥️',
        description: 'Monitor 34 inch 144Hz',
      ),
      "category": "Monitor",
    },
    {
      "product": Product(
        id: '5',
        name: 'Streaming Microphone',
        price: 1200000,
        emoji: '🎙️',
        description: 'Microphone untuk streaming',
      ),
      "category": "Audio",
    },
    {
      "product": Product(
        id: '6',
        name: 'Gaming Headset',
        price: 900000,
        emoji: '🎧',
        description: 'Headset surround sound',
      ),
      "category": "Audio",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Accessories', 'Furniture', 'Monitor', 'Audio'];

    final filteredProducts = products.where((item) {
      final product = item["product"] as Product;
      final category = item["category"] as String;

      final matchesCategory =
          selectedCategory == 'All' || category == selectedCategory;

      final matchesSearch = product.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Consumer<CartModel>(
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ),
                      );
                    },
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // 🔎 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search product...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // 📂 CATEGORY FILTER
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // 📋 PRODUCT LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index]["product"] as Product;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Text(
                      product.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.description),
                        Text(
                          'Rp ${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        context.read<CartModel>().addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} ditambahkan!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
