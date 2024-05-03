import 'package:flutter/material.dart';

import '../DbHelper/DbHelper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  final dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: RefreshIndicator(
        onRefresh: () => dbHelper.getData(),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: dbHelper.getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<Map<String, dynamic>> allProducts = snapshot.data!;
              List<Map<String, dynamic>> nonZeroCartProducts = allProducts
                  .where((product) => product['cartCount'] != 0)
                  .toList();

              return ListView.builder(
                itemCount: nonZeroCartProducts.length,
                itemBuilder: (context, index) {
                  final product = nonZeroCartProducts[index];
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product ID: ${product['id']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        Text('Product Name: ${product['productName']}'),
                        const SizedBox(height: 8.0),
                        Text('Cart Count: ${product['cartCount']}'),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),

    );
  }
}
