<?php
$host = "localhost";
$port = "5432";
$dbname ="Blockcode";
$user = "postgres";
$password = "halo.666";

$conn = pg_connect("host=$host port=$port dbname=$dbname user=$user password=$password");

if (!$conn) {
    echo json_encode(["error" => "DB connection failed"]);
    exit;
}
?>