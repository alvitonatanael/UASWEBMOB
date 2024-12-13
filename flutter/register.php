<?php
// Mengatur header agar dapat diakses oleh berbagai sumber (CORS)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

//Menghubungkan ke database
require "connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $nama = $_POST['nama'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $alamat = $_POST['alamat'];
    $telepon = $_POST['telepon'];

    $fotoName = "";
    if (isset($_FILES['foto'])) {
        $targetDir = "uploads/";
        $fotoName = uniqid() . "_" . basename($_FILES['foto']['name']);
        $targetFilePath = $targetDir . $fotoName;

        if (!move_uploaded_file($_FILES['foto']['tmp_name'], $targetFilePath)) {
            $response["success"] = false;
            $response["message"] = "Gagal mengunggah foto.";
            echo json_encode($response);
            exit();
        }
    }

    $stmt = $connect->prepare("INSERT INTO users (nama, email, password, alamat, telepon, foto) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("ssssss", $nama, $email, $password, $alamat, $telepon, $fotoName);
    if ($stmt->execute()) {
        $response["success"] = true;
        $response["nama"] = $nama;
    } else {
        $response["success"] = false;
        $response["message"] = "Gagal registrasi.";
    }
    echo json_encode($response);
}


