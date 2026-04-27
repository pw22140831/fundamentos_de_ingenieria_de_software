<?php
header("Content-Type: application/json");
include("../../config/database.php");

$data = json_decode(file_get_contents("php://input"), true);

$query = "CALL sp_insertar_proyecto(:nombre, :responsable, :inicio, :fin, :presupuesto)";
$stmt = $conn->prepare($query);

$stmt->execute([
    ":nombre" => $data["nombre"],
    ":responsable" => $data["responsable"],
    ":inicio" => $data["fecha_inicio"],
    ":fin" => $data["fecha_fin"],
    ":presupuesto" => $data["presupuesto"]
]);

echo json_encode(["message" => "Proyecto creado"]);