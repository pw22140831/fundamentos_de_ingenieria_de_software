<?php
header("Content-Type: application/json");
include("../../config/database.php");

$data = json_decode(file_get_contents("php://input"), true);

$query = "CALL sp_actualizar_rol(:id, :nombre)";
$stmt = $conn->prepare($query);

$stmt->execute([
    ":id" => $data["id_rol"],
    ":nombre" => $data["nombre"]
]);

echo json_encode(["message" => "Rol actualizado"]);