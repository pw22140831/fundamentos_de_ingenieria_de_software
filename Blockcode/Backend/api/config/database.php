<?php
$host = "localhost";
$port = "5432";
$dbname ="my_app";
$user = "my_app_role";
$password = "some_password";

$conn = pg_connect("host=$host port=$port dbname=$dbname user=$user password=$password");

if (!$conn) {
    echo json_encode(["error" => "DB connection failed"]);
    exit;
}
?>
