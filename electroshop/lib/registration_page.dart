import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';  // Import package image_picker
import 'dart:io';  // Untuk mengakses File gambar

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _image;  // Untuk menyimpan gambar yang diambil

  final _formKey = GlobalKey<FormState>();

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    // Pilih gambar dari galeri
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        // Tidak ada gambar yang dipilih
        print('No image selected');
      }
    });
  }

  // Fungsi untuk mendaftar
  void _register() {
    if (_formKey.currentState!.validate()) {
      // Proses registrasi (misalnya simpan data ke server atau database)
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      // Simulasi proses registrasi berhasil
      print("Registrasi berhasil: $name, $email, $password");

      // Arahkan ke halaman login setelah registrasi sukses
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrasi")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Foto Profil
              GestureDetector(
                onTap: _pickImage,  // Ketika foto dipilih, panggil fungsi _pickImage
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(Icons.add_a_photo, size: 40)
                      : null,
                ),
              ),
              SizedBox(height: 20),

              // Kolom untuk memasukkan nama
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nama"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Kolom untuk memasukkan email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Kolom untuk memasukkan password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Tombol untuk registrasi
              ElevatedButton(
                onPressed: _register,
                child: Text("Daftar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
