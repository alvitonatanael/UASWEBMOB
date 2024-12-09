import 'package:flutter/material.dart';

class TransactionHistoryPage extends StatelessWidget {
  final List<Map<String, String>> transactions = [
    {'product': 'Laptop HP', 'quantity': '1', 'total': '10,000,000'},
    {'product': 'Smartphone Samsung', 'quantity': '2', 'total': '10,000,000'},
    {'product': 'Headphone Sony', 'quantity': '3', 'total': '4,500,000'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat Transaksi")),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text("Produk: ${transactions[index]['product']}"),
              subtitle: Text("Jumlah: ${transactions[index]['quantity']}"),
              trailing: Text("Total: ${transactions[index]['total']}"),
            ),
          );
        },
      ),
    );
  }
}
