import 'package:flutter/material.dart';
import 'dashboard_page.dart'; // Pastikan Anda memiliki file ini
import 'forgot_password_page.dart'; // Halaman untuk pemulihan password
import 'registration_page.dart'; // Halaman untuk registrasi

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Fungsi untuk memvalidasi dan melakukan login
  void _login() {
    if (_formKey.currentState!.validate()) {
      // Proses login, misalnya pengecekan email dan password (di sini hanya contoh sederhana)
      String email = _emailController.text;
      String password = _passwordController.text;

      // Misalnya login berhasil, langsung arahkan ke halaman Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Perusahaan
            Image.asset(
              'aset/gambar/logo.jpg', // Ganti dengan path logo yang sesuai
              height: 100, // Sesuaikan ukuran logo
              width: 100,
            ),
            SizedBox(height: 16.0),

            // Form Login
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Kolom untuk memasukkan email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      } else if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(value)) {
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
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  // Tombol login
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Link untuk lupa password
                  TextButton(
                    onPressed: () {
                      // Arahkan ke halaman lupa password
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage()),
                      );
                    },
                    child: Text('Lupa Password?'),
                  ),

                  // Link untuk registrasi akun
                  TextButton(
                    onPressed: () {
                      // Arahkan ke halaman registrasi
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationPage()),
                      );
                    },
                    child: Text('Belum punya akun? Daftar sekarang!'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
