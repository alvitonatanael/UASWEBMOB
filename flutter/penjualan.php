<?php 
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

require "connect.php";

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $response = array();

    // Ambil data dari POST
    $id_produk = $_POST['id_produk'] ?? null;
    $harga_produk = $_POST['harga_produk'] ?? null;
    $quantity = $_POST['quantity'] ?? 1;
    $email = $_POST['email'] ?? null;
    $tanggal = date('Y-m-d');
    $voucher = $_POST['voucher'] ?? 0;

    // Validasi input
    if (empty($email) || empty($id_produk) || empty($harga_produk)) {
        $response['value'] = 0;
        $response['message'] = 'Email, id_produk, dan harga_produk tidak boleh kosong.';
        echo json_encode($response);
        exit;
    }

    // Cari ID pengguna berdasarkan email
    $stmt = $connect->prepare("SELECT id FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->bind_result($user);
    $stmt->fetch();
    $stmt->close();

    if (!$user) {
        $response['value'] = 0;
        $response['message'] = "Pengguna dengan email $email tidak ditemukan.";
        echo json_encode($response);
        exit;
    }

    $stmt = $connect->prepare("SELECT potongan FROM voucher WHERE nama_voucher = ?");
    $stmt->bind_param("i", $voucher);
    $stmt->execute();
    $stmt->bind_result($potongan);
    $stmt->fetch();
    $stmt->close();

    // Konversi harga ke float jika diperlukan
    $harga_produk1 = (int)$harga_produk - (int)$potongan;

    // Simpan ke tabel `history`
    $stmt = $connect->prepare("INSERT INTO history (id_pengguna, tgljual, idproduct, price, quantity) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param("sssss", $user, $tanggal, $id_produk, $harga_produk1, $quantity);

    if (!$stmt->execute()) {
        $response['value'] = 0;
        $response['message'] = 'Gagal menyimpan data ke tabel history: ' . $stmt->error;
        echo json_encode($response);
        exit;
    }
    $stmt->close();

    // Simpan ke tabel `jual`
    $stmt = $connect->prepare("INSERT INTO jual (tgljual, idproduct, price, quantity) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssdi", $tanggal, $id_produk, $harga_produk, $quantity);

    if ($stmt->execute()) {
        $response['value'] = 1;
        $response['message'] = 'Pembelian berhasil diproses.';
    } else {
        $response['value'] = 0;
        $response['message'] = 'Gagal menyimpan data ke tabel jual: ' . $stmt->error;
    }
    $stmt->close();

    // Kirim respons JSON
    echo json_encode($response);
} else {
    $response['value'] = 0;
    $response['message'] = "Permintaan tidak valid.";
    echo json_encode($response);
}
?>