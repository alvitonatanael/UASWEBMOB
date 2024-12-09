import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil Pengguna")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nama Lengkap"),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simpan perubahan profil di sini
                String name = _nameController.text;
                String email = _emailController.text;

                // Tampilkan dialog konfirmasi
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text("Profil Diperbarui"),
                    content: Text("Nama: $name\nEmail: $email"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              child: Text("Perbarui Profil"),
            ),
          ],
        ),
      ),
    );
  }
}
