<?php
header("Content-Type: application/json");
include("../../config/database.php");

$data = json_decode(file_get_contents("php://input"), true);

$query = "CALL sp_insertar_rol(:nombre)";
$stmt = $conn->prepare($query);

$stmt->execute([
    ":nombre" => $data["nombre"]
]);

echo json_encode(["message" => "Rol creado"]);