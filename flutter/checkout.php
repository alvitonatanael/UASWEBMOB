<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require "connect.php"; // Koneksi ke database

$response = array(); // Untuk menampung hasil akhir

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Read raw POST data
    $input = json_decode(file_get_contents('php://input'), true); // Decode JSON to an associative array

    // Check if email and belanja are set in the decoded JSON
    if (isset($input['email']) && isset($input['belanja'])) {
        $email = $input['email']; // Get the email
        $belanja = $input['belanja']; // Get the selected product IDs from checkboxes
        $tanggal = date('Y-m-d'); // Get today's date
        $quantity = isset($input['quantity']) ? $input['quantity'] : 1; // Use a default quantity of 1 if not provided

        // Check if the email exists in the database
        $stmt = $connect->prepare("SELECT id FROM users WHERE email = ?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $stmt->bind_result($user);
        $stmt->fetch();
        $stmt->close();

        if ($user) {
            // Loop through the selected product IDs (belanja)
            foreach ($belanja as $product_id) {
                // Retrieve product data based on the product ID
                $stmt = $connect->prepare("SELECT idproduct, price FROM namaproduct WHERE idproduct = ?");
                $stmt->bind_param("s", $product_id);
                $stmt->execute();
                $stmt->bind_result($id, $price);
                $stmt->fetch();
                $stmt->close();

                if ($id) {
                    // Insert into the jual (sale) table
                    $stmt = $connect->prepare("INSERT INTO jual (tgljual, idproduct, price, quantity) VALUES (?, ?, ?, ?)");
                    $stmt->bind_param("ssii", $tanggal, $id, $price, $quantity);
                    $stmt->execute();
                    $stmt->close();

                    // Insert into the history table
                    $stmt = $connect->prepare("INSERT INTO history (id_pengguna, tgljual, idproduct, price, quantity) VALUES (?, ?, ?, ?, ?)");
                    $stmt->bind_param("sssss", $user, $tanggal, $id, $price, $quantity);
                    $stmt->execute();
                    $stmt->close();

                    // Remove item from keranjang (cart)
                    $stmt = $connect->prepare("DELETE FROM keranjang WHERE id_produk = ? AND id_pengguna = ?");
                    $stmt->bind_param("ss", $id, $user);
                    $stmt->execute();
                    $stmt->close();
                } else {
                    // Product not found
                    $response = array(
                        "status" => "error",
                        "message" => "Product with ID $product_id not found."
                    );
                    echo json_encode($response);
                    exit;
                }
            }

            // Success response
            $response = array(
                "status" => "success",
                "message" => "Products purchased successfully."
            );
        } else {
            // User not found with the provided email
            $response = array(
                "status" => "error",
                "message" => "User with email $email not found."
            );
        }
    } else {
        // Response if email or belanja is not provided
        $response = array(
            "status" => "error",
            "message" => "Parameter 'email' or 'belanja' is missing."
        );
    }
} else {
    // Response for invalid HTTP method
    $response = array(
        "status" => "error",
        "message" => "Invalid HTTP method."
    );
}

// Output JSON response
echo json_encode($response);
?>
