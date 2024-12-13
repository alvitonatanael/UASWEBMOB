<?php
// Mengatur header agar dapat diakses oleh berbagai sumber (CORS)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

//Menghubungkan ke database
require "connect.php";

if($_SERVER['REQUEST_METHOD']== 'POST'){
    $email = $_POST['email'];
    $password = $_POST['password'];
    //$foto = $_POST['foto'];
 
    $stmt = $connect->prepare("UPDATE users SET password = ? WHERE email = ? ");
    $stmt->bind_param("ss",$password,$email);
    $stmt->execute();
    $response["success"] = true;
    echo json_encode($response);
    $stmt->close();
    exit();
}else{
    exit();
}
?>