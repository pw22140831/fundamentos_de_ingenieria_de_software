<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include(__DIR__ . "/../config/database.php");

$query = "SELECT * FROM users ORDER BY id DESC";
$result = pg_query($conn, $query);

$users = [];

while ($row = pg_fetch_assoc($result)) {
    $users[] = $row;
}

echo json_encode($users);