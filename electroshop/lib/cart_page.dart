import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<Map<String, dynamic>> cartItems = [
    {'name': 'Laptop HP', 'price': 10000000, 'quantity': 1},
    {'name': 'Smartphone Samsung', 'price': 5000000, 'quantity': 2},
  ];

  @override
  Widget build(BuildContext context) {
    num totalPrice = 0;  // Ubah tipe menjadi 'num'
    cartItems.forEach((item) {
      totalPrice += item['price'] * item['quantity'];
    });

    return Scaffold(
      appBar: AppBar(title: Text("Keranjang Belanja")),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(cartItems[index]['name']),
              subtitle: Text("Harga: ${cartItems[index]['price']} x ${cartItems[index]['quantity']}"),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    cartItems.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: ListTile(
          title: Text("Total: Rp ${totalPrice.toInt()}"),  // Cast 'totalPrice' to int for display
          trailing: ElevatedButton(
            onPressed: () {
              // Arahkan ke halaman pembayaran
            },
            child: Text("Lanjutkan Pembayaran"),
          ),
        ),
      ),
    );
  }
}

