import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  final String email;

  HistoryPage({required this.email});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    getHistory(widget.email);
  }

  Future<void> getHistory(String email) async {
    final String url =
        'http://192.168.43.162/flutter/get_history.php?email=$email';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          products = data['products'];
        });
      } else {
        // Handle error message
        print('Error: ${data['message']}');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Riwayat Pembelian"),
      ),
      body: products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                var product = products[index];
                return Card(
                  child: ListTile(
                    title: Text('ID Produk: ${product['idproduct']}'),
                    subtitle: Text('Tanggal: ${product['tgljual']}'),
                    isThreeLine:
                        true, // Untuk menampilkan lebih banyak informasi
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Menampilkan harga produk
                        Text(
                          'Harga: \$${product['price']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Menampilkan kuantitas pembelian
                        Text('Kuantitas: ${product['quantity']}'),
                        // Menampilkan ID penyimpanan
                        Text('ID Penyimpanan: ${product['id_penyimpanan']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
