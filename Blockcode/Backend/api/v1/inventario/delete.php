<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include("../../config/database.php");

$data = json_decode(file_get_contents("php://input"), true);

$query = "
DELETE FROM inventario
WHERE id_inventario = :id_inventario
";

$stmt = $conn->prepare($query);

$stmt->execute([
    ":id_inventario" => $data["id_inventario"]
]);

echo json_encode([
    "success" => true,
    "message" => "Inventario eliminado"
]);