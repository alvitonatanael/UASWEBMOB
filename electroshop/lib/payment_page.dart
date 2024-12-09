import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Proses Pembayaran")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Pilih Metode Pembayaran:"),
            ListTile(
              title: Text("Transfer Bank"),
              leading: Radio<String>(
                value: 'Transfer',
                groupValue: '',
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: Text("E-Wallet"),
              leading: Radio<String>(
                value: 'E-Wallet',
                groupValue: '',
                onChanged: (value) {},
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Proses pembayaran selesai
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Pembayaran Berhasil"),
                      content: Text("Pembayaran telah berhasil diproses."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Tutup"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("Bayar Sekarang"),
            ),
          ],
        ),
      ),
    );
  }
}
