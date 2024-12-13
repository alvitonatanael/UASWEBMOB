<?php
// Mengatur header agar dapat diakses oleh berbagai sumber (CORS)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Menghubungkan ke database
require "connect.php";

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $response = array(); // Inisialisasi array untuk menyimpan respons

    // Mengambil email dan password dari POST request
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Menyiapkan query untuk mengambil data pengguna berdasarkan email
    $stmt = $connect->prepare("SELECT email, password, nama, foto FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->bind_result($dbEmail, $dbPassword, $nama, $foto);
    $stmt->fetch();

    // Mengecek apakah email ditemukan dan password cocok
    if ($dbEmail) {
        if ($password == $dbPassword) { // Pastikan gunakan hashing password di implementasi sebenarnya
            $response['value'] = 1;
            $response['message'] = 'Login Berhasil';
            $response['nama'] = $nama;
            $response['foto'] = "http://192.168.43.162/flutter/uploads/" . $foto; // Menambahkan URL foto
        } else {
            $response['value'] = 0;
            $response['message'] = 'Login gagal. Password salah.';
        }
    } else {
        $response['value'] = 0;
        $response['message'] = 'Login gagal. Email tidak ditemukan.';
    }

    // Mengembalikan respons dalam format JSON
    echo json_encode($response);
} else {
    $response['value'] = 0;
    $response['message'] = "Permintaan tidak valid";
    echo json_encode($response);
}
