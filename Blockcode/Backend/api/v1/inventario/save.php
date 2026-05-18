<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include("../../config/database.php");

$data = json_decode(file_get_contents("php://input"), true);

$query = "
CALL sp_insertar_inventario(
    :p_id_proyecto,
    :p_nombre_recurso,
    :p_cantidad,
    :p_estado
)
";

$stmt = $conn->prepare($query);

$stmt->execute([
    ":p_id_proyecto" => $data["id_proyecto"],
    ":p_nombre_recurso" => $data["nombre_recurso"],
    ":p_cantidad" => $data["cantidad"],
    ":p_estado" => $data["estado"]
]);

echo json_encode([
    "success" => true,
    "message" => "Inventario creado"
]);
?>