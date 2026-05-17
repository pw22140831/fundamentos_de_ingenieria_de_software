<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include("../../config/database.php");

$query = "
SELECT
    t.id_transaccion,
    t.id_proyecto,
    p.nombre AS proyecto,
    t.id_usuario,
    u.nombre AS usuario,
    t.id_proveedor,
    pr.nombre AS proveedor,
    t.tipo,
    t.monto,
    t.fecha,
    t.descripcion,
    t.fecha_registro
FROM transacciones t
INNER JOIN proyectos p
ON t.id_proyecto = p.id_proyecto
INNER JOIN usuarios u
ON t.id_usuario = u.id_usuario
LEFT JOIN proveedores pr
ON t.id_proveedor = pr.id_proveedor
WHERE t.is_active = TRUE
ORDER BY t.id_transaccion ASC
";

$stmt = $conn->prepare($query);
$stmt->execute();

echo json_encode(
    $stmt->fetchAll(PDO::FETCH_ASSOC)
);
?>