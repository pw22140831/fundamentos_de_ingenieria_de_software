<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include("../../config/database.php");

$data = json_decode(file_get_contents("php://input"), true);

$query = "
CALL sp_eliminar_inventario(
    :p_id_inventario
)
";

$stmt = $conn->prepare($query);

$stmt->execute([
    ":p_id_inventario" => $data["id_inventario"]
]);

echo json_encode([
    "success" => true,
    "message" => "Inventario eliminado"
]);
?>