<?php
header("Content-Type: application/json");
include("../../config/database.php");

$query = "SELECT * FROM vw_usuarios";
$stmt = $conn->prepare($query);
$stmt->execute();

echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));