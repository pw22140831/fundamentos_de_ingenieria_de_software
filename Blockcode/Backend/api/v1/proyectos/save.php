<?php
header("Content-Type: application/json");
include("../../config/database.php");

$data = json_decode(file_get_contents("php://input"), true);

// require_once "../../middleware/auth.php"; -> Uncomment on next sprint
// require_once "../../utils/setAuditUser.php"; -> Uncomment on next sprint

$conn->beginTransaction();

// setAuditUser($conn); -> Uncomment on next sprint

$query = "CALL sp_insertar_proyecto(:nombre, :responsable, :inicio, :fin, :presupuesto)";
$stmt = $conn->prepare($query);

$stmt->execute([
    ":nombre" => $data["nombre"],
    ":responsable" => $data["responsable"],
    ":inicio" => $data["fecha_inicio"],
    ":fin" => $data["fecha_fin"],
    ":presupuesto" => $data["presupuesto"]
]);

$conn->commit();

echo json_encode(["message" => "Proyecto creado"]);