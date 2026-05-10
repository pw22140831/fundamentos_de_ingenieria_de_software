<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include("../../config/database.php");

$data = json_decode(file_get_contents("php://input"), true);

$query = "
UPDATE inventario
SET
    id_proyecto = :id_proyecto,
    nombre_recurso = :nombre_recurso,
    cantidad = :cantidad,
    estado = :estado,
    fecha_actualizacion = NOW()
WHERE id_inventario = :id_inventario
";

$stmt = $conn->prepare($query);

$stmt->execute([
    ":id_inventario" => $data["id_inventario"],
    ":id_proyecto" => $data["id_proyecto"],
    ":nombre_recurso" => $data["nombre_recurso"],
    ":cantidad" => $data["cantidad"],
    ":estado" => $data["estado"]
]);

echo json_encode([
    "success" => true,
    "message" => "Inventario actualizado"
]);