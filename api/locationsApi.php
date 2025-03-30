<?php
$mysqli = new mysqli("localhost", "root", "", "clinic_system");

$query = "SELECT business_name, account_id, street, barangay, city, province, region FROM clinic_business_account";
$result = $mysqli->query($query);

$locations = [];
while ($row = $result->fetch_assoc()) {
    $locations[] = $row;
}

header('Content-Type: application/json');
echo json_encode($locations);
?>
