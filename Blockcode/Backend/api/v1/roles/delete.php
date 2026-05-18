<?php
header("Content-Type: application/json");
include("../../config/database.php");

$data = json_decode(file_get_contents("php://input"), true);

$query = "CALL sp_eliminar_rol(:id)";
$stmt = $conn->prepare($query);

$stmt->execute([
    ":id" => $data["id_rol"]
]);

echo json_encode(["message" => "Rol eliminado"]);