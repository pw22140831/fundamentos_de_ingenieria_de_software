<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include("../../config/database.php");

$data = json_decode(file_get_contents("php://input"), true);

$query = "
INSERT INTO inventario (
    id_proyecto,
    nombre_recurso,
    cantidad,
    estado
)
VALUES (
    :id_proyecto,
    :nombre_recurso,
    :cantidad,
    :estado
)
";

$stmt = $conn->prepare($query);

$stmt->execute([
    ":id_proyecto" => $data["id_proyecto"],
    ":nombre_recurso" => $data["nombre_recurso"],
    ":cantidad" => $data["cantidad"],
    ":estado" => $data["estado"]
]);

echo json_encode([
    "success" => true,
    "message" => "Inventario creado"
]);