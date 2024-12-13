<?php 
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type");
    
    $connect = new mysqli("localhost", "root", "", "db_latihan");
    if($connect){
    }else{
        echo "Koneksi gagal";
        exit();
    }
?>