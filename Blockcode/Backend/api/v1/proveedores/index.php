<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include("../../config/database.php");

$query = "
SELECT
    id_proveedor,
    nombre,
    contacto,
    telefono,
    correo,
    fecha_creacion
FROM proveedores
WHERE is_active = TRUE
ORDER BY id_proveedor ASC
";

$stmt = $conn->prepare($query);

$stmt->execute();

echo json_encode(
    $stmt->fetchAll(PDO::FETCH_ASSOC)
);

?>