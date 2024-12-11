<?php 
//Mengatur header agar dapat diakses oleh berbagai sumber (COR5)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

//Menghubungkan ke database
require "connect.php";

if($_SERVER['REQUEST_METHOD'] == "POST") {
    $response = array(); //Inisialisasi array untuk respon

    //Mengambil data dari POST request
    $id_produk = $_POST['id_produk'] ?? null;
    $harga_produk = $_POST['harga_produk'] ?? null;
    $email = $_POST['email'] ?? null;

    $stmt = $connect->prepare("SELECT id FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->bind_result($user);
    $stmt->fetch();
    $stmt->close();

    //Cek apakah field harga_produk dan id_produk terisi
    if(!empty($harga_produk) && !empty($id_produk)) {
        //Konversi harga menjadi float dan bagi 100 untuk mengurangi dua digit
        $harga_produk = floatval($harga_produk) / 100;

        //Menggunakan prepared statement
        $stmt = $connect->prepare("INSERT INTO keranjang (id_pengguna, id_produk, harga) VALUES (?, ?, ?)");
        $stmt->bind_param("ssi", $user, $id_produk, $harga_produk);

        //Menjalankan query
        if ($stmt->execute()) {
            //Jika penyimpanan berhasil
            $response['value'] = 1;
            $response['message'] = 'Pembelian berhasil diproses';
        } else {
            //Jika terjadi kesalahan saat menyimpan
            $response['value'] = 0;
            $response['message'] = 'Gagal menyimpan data: ' . $stmt->error;
        }

        $stmt->close(); // Menutup statement
    } else {
        //Jika field harga_produk atau id_produk kosong
        $response['value'] = 0;
        $response['message'] = 'Field harga_produk dan id_produk tidak boleh kosong.';
    }

    //Mengembalikan respons dalam format JSON
    echo json_encode($response);
} else {
    //Jika request method bukan POST
    $response['value'] = 0;
    $response['message'] = "Permintaan tidak valid";
    echo json_encode($response);
}
?>