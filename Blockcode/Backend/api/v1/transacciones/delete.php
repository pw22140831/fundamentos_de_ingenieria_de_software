<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include("../../config/database.php");

$data = json_decode(file_get_contents("php://input"), true);

$query = "
CALL sp_eliminar_transaccion(
    :p_id_transaccion
)
";

$stmt = $conn->prepare($query);

$stmt->execute([
    ":p_id_transaccion" => $data["id_transaccion"]
]);

echo json_encode([
    "success" => true,
    "message" => "Transacción eliminada"
]);
?>