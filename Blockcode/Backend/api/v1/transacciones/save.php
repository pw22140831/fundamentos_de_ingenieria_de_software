<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include("../../config/database.php");

$data = json_decode(file_get_contents("php://input"), true);

$query = "
CALL sp_insertar_transaccion(
    :p_id_proyecto,
    :p_id_usuario,
    :p_id_proveedor,
    :p_tipo,
    :p_monto,
    :p_fecha,
    :p_descripcion
)
";

$stmt = $conn->prepare($query);

$stmt->execute([
    ":p_id_proyecto" => $data["id_proyecto"],
    ":p_id_usuario" => $data["id_usuario"],
    ":p_id_proveedor" => $data["id_proveedor"],
    ":p_tipo" => $data["tipo"],
    ":p_monto" => $data["monto"],
    ":p_fecha" => $data["fecha"],
    ":p_descripcion" => $data["descripcion"]
]);

echo json_encode([
    "success" => true,
    "message" => "Transacción creada"
]);
?>