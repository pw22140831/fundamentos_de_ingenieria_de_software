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
CALL sp_actualizar_proveedor(
    :p_id_proveedor,
    :p_nombre,
    :p_contacto,
    :p_telefono,
    :p_correo
)
";

$stmt = $conn->prepare($query);

$stmt->execute([
    ":p_id_proveedor" => $data["id_proveedor"],
    ":p_nombre" => $data["nombre"],
    ":p_contacto" => $data["contacto"],
    ":p_telefono" => $data["telefono"],
    ":p_correo" => $data["correo"]
]);

echo json_encode([
    "success" => true,
    "message" => "Proveedor actualizado"
]);

?>