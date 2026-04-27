<?php
header("Content-Type: application/json");
include("../../config/database.php");

$data = json_decode(file_get_contents("php://input"), true);

$query = "CALL sp_actualizar_usuario(:id, :nombre, :ap_pat, :ap_mat, :correo, :pass, :rol, :activo)";
$stmt = $conn->prepare($query);

$stmt->execute([
    ":id" => $data["id_usuario"],
    ":nombre" => $data["nombre"],
    ":ap_pat" => $data["apellido_paterno"],
    ":ap_mat" => $data["apellido_materno"],
    ":correo" => $data["correo"],
    ":pass" => $data["password_hash"],
    ":rol" => $data["id_rol"],
    ":activo" => $data["activo"]
]);

echo json_encode(["message" => "Usuario actualizado"]);