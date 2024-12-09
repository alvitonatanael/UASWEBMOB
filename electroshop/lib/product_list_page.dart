import 'package:flutter/material.dart';
import 'transaction_page.dart';

class ProductListPage extends StatelessWidget {
  final List<Map<String, String>> products = [
    {'name': 'Laptop HP', 'price': '10,000,000'},
    {'name': 'Smartphone Samsung', 'price': '5,000,000'},
    {'name': 'Headphone Sony', 'price': '1,500,000'},
    {'name': 'Smartwatch Garmin', 'price': '3,000,000'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Produk")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(products[index]['name']!),
              subtitle: Text("Harga: ${products[index]['price']}"),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  // Arahkan ke halaman transaksi dengan produk yang dipilih
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TransactionPage(product: products[index]),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
