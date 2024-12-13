<?php 
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require "connect.php"; // Koneksi ke database

$response = array(); // Untuk menampung hasil akhir

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['email'])) {
        $email = $_GET['email'];
        
        // Query untuk mendapatkan ID pengguna berdasarkan email
        $stmt = $connect->prepare("SELECT id FROM users WHERE email = ?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $stmt->bind_result($id);
        $stmt->fetch();
        $stmt->close();

        if ($id) {
            // Query untuk mendapatkan riwayat berdasarkan ID pengguna
            $query = "SELECT * FROM history WHERE id_pengguna = ?";
            $stmt2 = $connect->prepare($query);
            $stmt2->bind_param("i", $id);
            $stmt2->execute();
            $result = $stmt2->get_result();

            $products = array();
            while ($row = $result->fetch_assoc()) {
                $products[] = $row;
            }
            $stmt2->close();

            // Response sukses
            $response = array(
                "status" => "success",
                "products" => $products
            );
        } else {
            // Response jika ID pengguna tidak ditemukan
            $response = array(
                "status" => "error",
                "message" => "Pengguna dengan email $email tidak ditemukan."
            );
        }
    } else {
        // Response jika email tidak disediakan
        $response = array(
            "status" => "error",
            "message" => "Parameter 'email' tidak ditemukan."
        );
    }
} else {
    // Response untuk metode selain GET
    $response = array(
        "status" => "error",
        "message" => "Metode HTTP tidak valid."
    );
}

// Output JSON
echo json_encode($response);
?>
