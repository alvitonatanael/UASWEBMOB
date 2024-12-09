import 'package:flutter/material.dart';
import 'product_list_page.dart';
import 'transaction_history_page.dart';
import 'profile_page.dart';
import 'cart_page.dart';
import 'payment_page.dart';
import 'delivery_tracking.dart';
import 'repeat_purchase.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
        ),
        itemCount: 6, // Menambah jumlah menu
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildMenuCard(context, "Daftar Produk", ProductListPage());
          } else if (index == 1) {
            return _buildMenuCard(context, "Riwayat Transaksi", TransactionHistoryPage());
          } else if (index == 2) {
            return _buildMenuCard(context, "Keranjang Belanja", CartPage());
          } else if (index == 3) {
            return _buildMenuCard(context, "Pembayaran", PaymentPage());
          } else if (index == 4) {
            return _buildMenuCard(context, "Tracking Pengiriman", DeliveryTrackingPage());
          } else if (index == 5) {
            return _buildMenuCard(context, "Pembelian Berulang", RepeatPurchasePage());
          } else {
            return _buildMenuCard(context, "Profil Pengguna", ProfilePage());
          }
        },
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, Widget page) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Center(child: Text(title)),
      ),
    );
  }
}

