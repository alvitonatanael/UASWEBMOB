<?php
// Mengatur header agar dapat diakses oleh berbagai sumber (CORS)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

//Menghubungkan ke database
require "connect.php";

if($_SERVER['REQUEST_METHOD']== 'POST'){
    $nama = $_POST['nama'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $alamat = $_POST['alamat'];
    $telepon = $_POST['telepon'];
    //$foto = $_POST['foto'];
    $foto = " ";

    $y = date("Y");
    $m = date("m");
    $d = date("d");
    $id = $y . $m . $d;
    $id = (int)$id;
    $id *= 10;

    $cek = "SELECT email, password FROM users WHERE id > $id";
    $result = mysqli_query($connect, $cek);

    $num = mysqli_num_rows($result);

    $id+=$num;
   
    $stmt = $connect->prepare("INSERT INTO users (id, email, password, nama, alamat, telepon, foto) VALUES (?,?,?,?,?,?,?)");
    $stmt->bind_param("sssssss",$id,$email,$password,$nama,$alamat,$telepon,$foto);
    $response["success"] = true;
    $response["nama"] =  $nama;
    echo json_encode($response);
    $stmt->close();
    exit();
}else{
    exit();
}
?>