<?php
header("Content-Type: application/json");
include("../../config/database.php");

$data = json_decode(file_get_contents("php://input"), true);

$query = "CALL sp_actualizar_proyecto(:id, :nombre, :responsable, :inicio, :fin, :presupuesto)";
$stmt = $conn->prepare($query);

$stmt->execute([
    ":id" => $data["id_proyecto"],
    ":nombre" => $data["nombre"],
    ":responsable" => $data["responsable"],
    ":inicio" => $data["fecha_inicio"],
    ":fin" => $data["fecha_fin"],
    ":presupuesto" => $data["presupuesto"]
]);

echo json_encode(["message" => "Proyecto actualizado"]);