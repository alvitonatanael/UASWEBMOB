import 'package:flutter/material.dart';
import 'login_page.dart';
import 'history_page.dart';
import 'keranjang_page.dart';
import 'product_page.dart'; // Import ProductPage

class DashboardPage extends StatelessWidget {
  final String userName;
  final String userPhoto; // Tambahkan parameter foto
  final String email; // Tambahkan parameter email

  // Konstruktor untuk menerima parameter userName, userPhoto, dan email
  DashboardPage({
    required this.userName,
    required this.userPhoto,
    required this.email, // Terima email di konstruktor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Konfirmasi Logout"),
                  content: Text("Apakah Anda yakin ingin keluar?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), // Tutup dialog
                      child: Text("Batal"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false,
                        );
                      },
                      child: Text("Keluar"),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue[50], // Set background color here
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menampilkan foto profil dari parameter userPhoto
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(userPhoto), // Tampilkan foto
                ),
              ),
              SizedBox(height: 16.0),
              // Menampilkan nama pengguna
              Text(
                "Selamat Datang, $userName!",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "Selamat Berbelanja",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              // UI lainnya seperti grid cards dan lain-lain...
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: [
                    // Menambahkan card untuk menuju halaman produk
                    _buildDashboardCard(
                      context,
                      title: "Produk",
                      icon: Icons.shopping_cart,
                      // Di dalam onTap produk pada DashboardPage
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPage(
                              email: email, // Kirim email ke ProductPage
                            ),
                          ),
                        );
                      },
                    ),
                    //Menambahkan card untuk menuju halaman history
                    _buildDashboardCard(
                      context,
                      title: "Riwayat",
                      icon: Icons.history,
                      onTap: () {
                        // Navigasi ke halaman Riwayat
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryPage(
                              email: email, // Kirim email ke HistoryPage
                            ),
                          ),
                        );
                      },
                    ),
                    _buildDashboardCard(
                      context,
                      title: "Keranjang",
                      icon: Icons.shopping_basket,
                      onTap: () {
                        // Navigasi ke halaman keranjang
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KeranjangPage(
                              email: email, // Kirim email ke KeranjangPage
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk membuat card di dashboard
  Widget _buildDashboardCard(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: Theme.of(context).primaryColor),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
