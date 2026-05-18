<?php

header("Content-Type: application/json");

include("../../config/database.php");

$data = json_decode(
    file_get_contents("php://input"),
    true
);

try {

    // =====================
    // PASSWORD
    // =====================

    $passwordHash = null;

    // NUEVA PASSWORD
    if (
        isset($data["password"]) &&
        trim($data["password"]) !== ""
    ) {

        $passwordHash = password_hash(
            $data["password"],
            PASSWORD_BCRYPT
        );

    }

    // =====================
    // QUERY
    // =====================

    $query = "
        CALL sp_actualizar_usuario(
            :id,
            :nombre,
            :ap_pat,
            :ap_mat,
            :correo,
            :pass,
            :rol,
            :activo
        )
    ";

    $stmt = $conn->prepare($query);

    $stmt->execute([

        ":id" =>
            $data["id_usuario"],

        ":nombre" =>
            $data["nombre"],

        ":ap_pat" =>
            $data["apellido_paterno"],

        ":ap_mat" =>
            $data["apellido_materno"],

        ":correo" =>
            $data["correo"],

        ":pass" =>
            $passwordHash,

        ":rol" =>
            $data["id_rol"],

        ":activo" =>
            $data["activo"] ?? true
    ]);

    echo json_encode([
        "success" => true,
        "message" => "Usuario actualizado"
    ]);

} catch (Exception $e) {

    http_response_code(500);

    echo json_encode([
        "success" => false,
        "message" => $e->getMessage()
    ]);
}