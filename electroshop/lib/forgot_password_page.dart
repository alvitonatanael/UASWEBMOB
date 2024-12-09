import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lupa Password")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika reset password di sini
              },
              child: Text("Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}
