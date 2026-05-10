<?php

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

$headers = getallheaders();

if (!isset($headers['Authorization'])) {
    http_response_code(401);

    echo json_encode([
        "success" => false,
        "message" => "Token requerido"
    ]);

    exit;
}

$authHeader = $headers['Authorization'];

$token = str_replace('Bearer ', '', $authHeader);

try {

    $decoded = JWT::decode(
        $token,
        new Key($_ENV["JWT_SECRET"], 'HS256')
    );

} catch (Exception $e) {

    http_response_code(401);

    echo json_encode([
        "success" => false,
        "message" => "Token inválido"
    ]);

    exit;
}