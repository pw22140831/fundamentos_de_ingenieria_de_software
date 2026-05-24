<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include("../../config/database.php");

$data = json_decode(
    file_get_contents("php://input"),
    true
);

$query = "
CALL sp_eliminar_proveedor(
    :p_id_proveedor
)
";

$stmt = $conn->prepare($query);

$stmt->execute([
    ":p_id_proveedor" => $data["id_proveedor"]
]);

echo json_encode([
    "success" => true,
    "message" => "Proveedor eliminado"
]);

?>