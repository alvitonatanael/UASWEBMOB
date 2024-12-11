<?php
// Mengatur header agar dapat diakses oleh berbagai sumber (CORS)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

//Menghubungkan ke database
require "connect.php";

if($_SERVER['REQUEST_METHOD'] == "POST") {
    $response = array(); //Inisialisasi array untuk menyimpan respons

    //Mengambil email dan password dari POST request
    $email = $_POST['email'];
    $password = $_POST['password']; //Password dari input form

    //Membuat query untuk mengambil data pengguna berdasarkan email
    $cek = "SELECT email, password FROM users WHERE email = '$email'";

    //Menjalankan query
    $result = mysqli_query($connect, $cek);

    $stmt = $connect->prepare("SELECT email, password, nama FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->bind_result($email1, $password1, $nama);
    $stmt->fetch();

    //Mengecek apakah hasil query valid
    if ($result && mysqli_num_rows($result) > 0) {
        //Mengambil apakah hasil query valid
        if ($result && mysqli_num_rows($result) > 0) {
            //Mengambil data pengguna dari database
            $row = mysqli_fetch_assoc($result);

            //Memverifikasi password yang tersimpan di database
            if ($password == $password1 && $email == $email1) {
                //Jika password cocok, login berhasil
                $response['value'] = 1;
                $response['message'] = 'Login Berhasil';
                $response["nama"] =  $nama;
            } else {
                //Jika password tidak cocok
                $repsonse['value'] = 0;
                $response['message'] = 'Login gagal. Password salah.';
            }
        } else {
            //Jika email tidka ditemukan di database
            $response['value'] = 0;
            $response['message'] = "Login gagal. Email tidak ditemukan.";
        }

        //Mengembalikan respons dalam format JSON
        echo json_encode($response);
    } else {
        //Jika request method bukan POST
        $response['value'] = 0;
        $response['message'] = "Permintaan tidak valid";
        echo json_encode($response);

    }
}
?>