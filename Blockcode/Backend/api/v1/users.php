<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include(__DIR__ . "/../config/database.php");

$query = "SELECT * FROM usuarios ORDER BY id DESC";
$result = pg_query($conn, $query);

if (!$result) {
    http_response_code(500);
    echo json_encode(['error' => pg_last_error($conn)]);
    exit();
}

$users = [];
while ($row = pg_fetch_assoc($result)) {
    $users[] = $row;
}

echo json_encode($users);