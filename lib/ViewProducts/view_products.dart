import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../Cart/cartPage.dart';
import '../DbHelper/DbHelper.dart';
import '../Model/productModel.dart';

class ViewProducts extends StatefulWidget {
  const ViewProducts({super.key});

  @override
  State<ViewProducts> createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {

  late List<Map<String, dynamic>> products;
  final dbHelper = DBHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Text(
          "Products",
        ),
        actions: [InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            child: Icon(Icons.shopping_bag))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
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
                 return ListView.builder(
                    itemCount: products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return InkWell(
                        onTap: () {
                          updateProductName(product['id'], product['cartCount'] + 1);
                        },
                        child: Container(
                        padding: const EdgeInsets.all(16.0),
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Stack(
                          children:[
                            Positioned(
                                top: 0,right: 0,child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100.0)), color: Colors.orangeAccent),
                              child: Icon(Icons.add, color: Colors.white,),
                            )),
                            Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product ID: ${product['id']}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8.0),
                              Text('Product Name: ${product['productName']}'),
                              SizedBox(height: 8.0),

                            ],
                          ),]
                        ),
                                                  ),
                      );
                    },
                  );
                }
              },
            ),
          ],

        ),
      ),
    );
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> data = await dbHelper.getData();
    setState(() {
      products = data;
    });
  }

  Future<void> getProducts() async {
    products = await dbHelper.getData();
    setState(() {}); // Refresh UI
  }


  Future<void> addProduct() async {
    Map<String, dynamic> product = {
      'productName': 'Table',
      'cartCount': 0,
    };
    await dbHelper.insertData(product);
    setState(() {}); // Refresh UI
  }

  Future<void> updateProductName(int productId, int cartCount) async {
    final dbHelper = DBHelper();
    Map<String, dynamic> newData = {'cartCount': cartCount};
    int rowsAffected = await dbHelper.updateData(productId, newData);
    fetchData();
    print('Updated $rowsAffected rows');
  }


}
