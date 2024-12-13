import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  final String email;

  ProductPage({required this.email});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<dynamic> _products = [];
  List<dynamic> _vouchers = [];
  String? _selectedVoucher;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchVouchers();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.43.162/flutter/get_products.php'),
      );

      if (response.statusCode == 200) {
        List<dynamic> products = json.decode(response.body);
        setState(() {
          _products = products;
        });
      } else {
        throw Exception('Gagal memuat data produk');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> _fetchVouchers() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.43.162/flutter/get_vouchers.php'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['value'] == 1) {
          setState(() {
            _vouchers = data['vouchers'];
          });
        } else {
          setState(() {
            _vouchers = [];
          });
        }
      } else {
        throw Exception('Gagal memuat daftar voucher');
      }
    } catch (e) {
      print('Error fetching vouchers: $e');
    }
  }

  Future<void> _addToCart({
    required String idProduk,
    required String hargaProduk,
  }) async {
    String email = widget.email;

    // Log data yang dikirim
    print("Data yang dikirim ke server untuk keranjang:");
    print("ID Produk: $idProduk");
    print("Harga Produk: $hargaProduk");
    print("Email: $email");

    try {
      final response = await http.post(
        Uri.parse('http://192.168.43.162/flutter/post_keranjang.php'),
        body: {
          'id_produk': idProduk,
          'harga_produk': hargaProduk,
          'email': email,
        },
      );

      // Log respons dari server
      print('Response body: ${response.body}');

      final responseData = json.decode(response.body);

      if (responseData['value'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${responseData['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _purchaseProduct({
    required String idProduk,
    required String hargaProduk,
    required int quantity,
    required String voucher,
  }) async {
    String email = widget.email;

    // Log data yang dikirim
    print("Data yang dikirim ke server:");
    print("ID Produk: $idProduk");
    print("Harga Produk: $hargaProduk");
    print("Quantity: $quantity");
    print("Voucher: $voucher");
    print("Email: $email");

    try {
      final response = await http.post(
        Uri.parse('http://192.168.43.162/flutter/penjualan.php'),
        body: {
          'id_produk': idProduk,
          'harga_produk': hargaProduk,
          'quantity': quantity.toString(),
          'email': email,
          'voucher': voucher,
        },
      );

      // Log respons dari server
      print('Response body: ${response.body}');

      final responseData = json.decode(response.body);

      if (responseData['value'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${responseData['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showPurchaseDialog(Map<String, dynamic> product) {
    int quantity = 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Pembelian'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID Produk: ${product['idproduct']}'),
              Text('Produk: ${product['product']}'),
              Text('Harga: Rp${product['price']}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Jumlah:'),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: '1'),
                      onChanged: (value) {
                        quantity = int.tryParse(value) ?? 1;
                      },
                    ),
                  ),
                ],
              ),
              DropdownButton<String>(
                value: _selectedVoucher,
                hint: Text("Pilih Voucher"),
                isExpanded: true,
                items: _vouchers.map((voucher) {
                  return DropdownMenuItem<String>(
                    value: voucher['nama_voucher'],
                    child: Text(voucher['nama_voucher']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVoucher = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _purchaseProduct(
                  idProduk: product['idproduct'],
                  hargaProduk: product['price'],
                  quantity: quantity,
                  voucher: _selectedVoucher ?? "0",
                );
              },
              child: Text('Beli'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Produk'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Selamat Berbelanja',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: _products.isEmpty
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.75,
                    ),
                    padding: EdgeInsets.all(10.0),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      var product = _products[index];
                      String productId = product['idproduct']?.toString() ??
                          'ID Tidak Tersedia';
                      String productName =
                          product['product'] ?? 'Nama Produk Tidak Tersedia';
                      String productPrice = product['price']?.toString() ??
                          'Harga Tidak Tersedia';
                      String productImage = product['image'] ?? '';

                      return Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: productImage.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10.0),
                                      ),
                                      child: Image.network(
                                        productImage,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey,
                                          );
                                        },
                                      ),
                                    )
                                  : Container(
                                      color: Colors.grey[200],
                                      child: Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ID: $productId', // Menampilkan ID produk
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    productName,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Rp$productPrice',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  ElevatedButton(
                                    onPressed: () =>
                                        _showPurchaseDialog(product),
                                    child: Text('Beli'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _addToCart(
                                        idProduk: product['idproduct'],
                                        hargaProduk: product['price'],
                                      );
                                    },
                                    child: Text('Tambah ke Keranjang'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
