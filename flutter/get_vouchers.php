<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

require "connect.php";

if ($_SERVER['REQUEST_METHOD'] == "GET") {
    $response = array();

    // Query untuk mengambil data voucher
    $stmt = $connect->prepare("SELECT id_voucher, nama_voucher, potongan FROM voucher");
    $stmt->execute();
    $result = $stmt->get_result();

    // Cek apakah ada data voucher
    if ($result->num_rows > 0) {
        $vouchers = array();
        while ($row = $result->fetch_assoc()) {
            $vouchers[] = $row;
        }
        $response['value'] = 1;
        $response['vouchers'] = $vouchers;
    } else {
        $response['value'] = 0;
        $response['message'] = 'Voucher tidak ditemukan.';
    }

    // Menutup statement dan mengirim respons JSON
    $stmt->close();
    echo json_encode($response);
} else {
    $response['value'] = 0;
    $response['message'] = "Permintaan tidak valid.";
    echo json_encode($response);
}
?>
