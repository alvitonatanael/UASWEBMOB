import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  final Map<String, String> product;

  // Konstruktor untuk menerima data produk yang dipilih
  const TransactionPage({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transaksi Pembelian")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Nama Barang"),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Jumlah Barang"),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Harga Barang"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk pemrosesan transaksi
              },
              child: Text("Beli"),
            ),
          ],
        ),
      ),
    );
  }
}
