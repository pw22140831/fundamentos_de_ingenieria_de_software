<?php
header("Content-Type: application/json");
include("../../config/database.php");

$data = json_decode(file_get_contents("php://input"), true);

$query = "CALL sp_eliminar_usuario(:id)";
$stmt = $conn->prepare($query);

$stmt->execute([
    ":id" => $data["id_usuario"]
]);

echo json_encode(["message" => "Usuario desactivado"]);