<?php
header("Content-Type: application/json");
include("../../config/database.php");

$data = json_decode(file_get_contents("php://input"), true);

$query = "CALL sp_insertar_usuario(:nombre, :ap_pat, :ap_mat, :correo, :pass, :rol, :activo)";
$stmt = $conn->prepare($query);

$stmt->execute([
    ":nombre" => $data["nombre"],
    ":ap_pat" => $data["apellido_paterno"],
    ":ap_mat" => $data["apellido_materno"],
    ":correo" => $data["correo"],
    ":pass" => password_hash($data["password"], PASSWORD_BCRYPT),
    ":rol" => $data["id_rol"],
    ":activo" => true
]);

echo json_encode(["message" => "Usuario creado"]);