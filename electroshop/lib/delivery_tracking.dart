import 'package:flutter/material.dart';

class DeliveryTrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tracking Pengiriman")),
      body: Center(
        child: Column(
          children: [
            Text("Masukkan Nomor Resi:"),
            TextField(),
            ElevatedButton(
              onPressed: () {
                // Tampilkan status pengiriman
              },
              child: Text("Cek Status Pengiriman"),
            ),
          ],
        ),
      ),
    );
  }
}
