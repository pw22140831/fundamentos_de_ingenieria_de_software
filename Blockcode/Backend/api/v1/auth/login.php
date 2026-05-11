<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

include("../../config/database.php");
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/../../../');
$dotenv->load();

require_once __DIR__ . '/../../../vendor/autoload.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

$data = json_decode(file_get_contents("php://input"), true);

$correo = $data["correo"];
$password = $data["password"];

$query = "SELECT * FROM vw_usuarios WHERE correo = :correo";

$stmt = $conn->prepare($query);

$stmt->execute([
    ":correo" => $correo
]);

$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    echo json_encode([
        "success" => false,
        "message" => "Usuario no encontrado"
    ]);
    exit;
}

if (!password_verify($password, $user["password_hash"])) {
    echo json_encode([
        "success" => false,
        "message" => "Contraseña incorrecta"
    ]);
    exit;
}

$payload = [
    "id_usuario" => $user["id_usuario"],
    "correo" => $user["correo"],
    "id_rol" => $user["id_rol"],
    "exp" => time() + 3600
];

$jwt = JWT::encode(
    $payload,
    $_ENV["JWT_SECRET"],
    'HS256'
);

unset($user["password_hash"]);

echo json_encode([
    "success" => true,
    "token" => $jwt,
    "user" => $user
]);
