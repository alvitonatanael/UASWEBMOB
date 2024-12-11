<?php 
//Mengatur header agar dapat diakses oleh berbagai sumber (COR5)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

//Menghubungkan ke database
require "connect.php";

if($_SERVER['REQUEST_METHOD'] == "POST") {
    $response = array(); //Inisialisasi array untuk respon

    try{
        //Mengambil data dari POST request
    $email = $_POST['email'];
    $rating = $_POST['rating'];
    $id_produk = $_POST['id_produk'];
    $deskripsi = $_POST['deskripsi'] ?? null;

    }catch(Exception $e){
        $response['value'] = 0;
        $response['message'] = "Permintaan tidak valid";
        echo json_encode($response);
        exit();
    }

    $stmt = $connect->prepare("INSERT INTO rating (id_product, email, rating, deskripsi) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssss",  $id_produk, $email, $rating, $deskripsi);
    $stmt->execute();
    $stmt->close();

    $stmt = $connect->prepare("SELECT AVG(rating) FROM rating WHERE id_product = ?");
    $stmt->bind_param("s", $id_produk);
    $stmt->execute();
    $stmt->bind_result($sum);
    $stmt->fetch();
    $stmt->close();

    //Cek apakah field harga_produk dan id_produk terisi
        echo($sum);
        //Menggunakan prepared statement
        $stmt = $connect->prepare("UPDATE namaproduct SET rating = ? WHERE idproduct = ? ");
        $stmt->bind_param("ds", $sum, $id_produk);

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
    echo json_encode($response);
    } else {
    //Jika request method bukan POST
        $response['value'] = 0;
        $response['message'] = "Permintaan tidak valid";
        echo json_encode($response);
    }
    
?>