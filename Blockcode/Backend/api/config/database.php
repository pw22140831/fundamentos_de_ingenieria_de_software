<?php
require_once __DIR__ . '/../vendor/autoload.php';

// Cargar variables de entorno desde Backend/api/.env
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

$host     = $_ENV['DB_HOST'];
$port     = $_ENV['DB_PORT'];
$dbname   = $_ENV['DB_NAME'];
$user     = $_ENV['DB_USER'];
$password = $_ENV['DB_PASS'];

$conn = pg_connect("host=$host port=$port dbname=$dbname user=$user password=$password");

if (!$conn) {
    echo json_encode(["error" => "DB connection failed"]);
    exit;
}
?>
