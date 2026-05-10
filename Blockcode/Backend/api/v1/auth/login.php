<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

include("../../config/database.php");

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

$data = json_decode(file_get_contents("php://input"), true);

$correo = $data["correo"];
$password = $data["password"];

$query = "
SELECT 
    u.id_usuario,
    u.nombre,
    u.apellido_paterno,
    u.apellido_materno,
    u.correo,
    u.password_hash,
    r.nombre AS rol,
    u.activo
FROM usuarios u
INNER JOIN roles r
ON u.id_rol = r.id_rol
WHERE u.correo = :correo
LIMIT 1
";

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
    "rol" => $user["rol"],
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