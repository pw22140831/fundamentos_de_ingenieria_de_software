<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include("../../config/database.php");

$query = "
SELECT
    i.id_inventario,
    i.id_proyecto,
    p.nombre AS proyecto,
    i.nombre_recurso,
    i.cantidad,
    i.estado,
    i.fecha_actualizacion
FROM inventario i
INNER JOIN proyectos p
ON i.id_proyecto = p.id_proyecto
ORDER BY i.id_inventario ASC
";

$stmt = $conn->prepare($query);
$stmt->execute();

$data = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($data);