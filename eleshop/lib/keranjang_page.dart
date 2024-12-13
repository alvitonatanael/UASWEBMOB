import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KeranjangPage extends StatefulWidget {
  final String email;

  KeranjangPage({required this.email});

  @override
  _KeranjangPageState createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  List<dynamic> _keranjangItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchKeranjang();
  }

  Future<void> _fetchKeranjang() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.43.162/flutter/get_keranjang.php?email=${widget.email}'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          _keranjangItems = data['products'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog(data['message']);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Gagal memuat data keranjang.');
    }
  }

  // Fungsi untuk checkout
  Future<void> _checkout() async {
    // Ambil id produk yang ada di keranjang
    List<String> belanja =
        _keranjangItems.map((item) => item['id_produk'].toString()).toList();

    final response = await http.post(
      Uri.parse('http://192.168.43.162/flutter/checkout.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': widget.email,
        'belanja': belanja,
      }),
    );

    final Map<String, dynamic> data = json.decode(response.body);
    if (data['status'] == 'success') {
      // Jika sukses, tampilkan dialog sukses
      _showSuccessDialog(data['message']);
    } else {
      // Jika gagal, tampilkan dialog error
      _showErrorDialog(data['message']);
    }
  }

  // Fungsi untuk menampilkan dialog error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terjadi Kesalahan'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan dialog sukses
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sukses'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Kembali ke halaman lain setelah sukses
              Navigator.pop(context);
            },
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Keranjang Belanja"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _keranjangItems.isEmpty
              ? Center(child: Text("Keranjang Anda kosong."))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _keranjangItems.length,
                        itemBuilder: (context, index) {
                          final item = _keranjangItems[index];
                          return ListTile(
                            title: Text(item['id_produk']),
                            subtitle: Text('Harga: ${item['harga']}'),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: _checkout, // Checkout button
                        child: Text('Checkout'),
                      ),
                    ),
                  ],
                ),
    );
  }
}
