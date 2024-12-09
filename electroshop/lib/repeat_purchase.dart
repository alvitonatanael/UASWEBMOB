import 'package:flutter/material.dart';

class RepeatPurchasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pembelian Berulang")),
      body: ListView.builder(
        itemCount: 5, // Replace with the number of past purchases
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Produk ${index + 1}"),
            subtitle: Text("Harga: 5,000,000"),
            trailing: ElevatedButton(
              onPressed: () {
                // Add item to cart
              },
              child: Text("Beli Lagi"),
            ),
          );
        },
      ),
    );
  }
}
