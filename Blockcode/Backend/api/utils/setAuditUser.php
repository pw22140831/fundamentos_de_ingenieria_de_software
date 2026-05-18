<?php

function setAuditUser($conn) {

    $usuario = $GLOBALS['auth_user'];

    $idUsuario = $usuario->id_usuario;

    $conn->exec("
        SET audit.user_id =
        '$idUsuario'
    ");
}