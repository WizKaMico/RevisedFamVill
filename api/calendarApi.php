<?php
header('Content-Type: application/json');
include('../controller/chartsApiController.php');

$account_id = $_GET['account_id'] ?? '';

$appointments = $portCont->myClinicSchedules($account_id);
$data = [];

foreach ($appointments as $row) {
    $data[] = [
        'id' => $row['aid'],
        'title' => $row['title'] ?? 'Appointment',
        'start' => $row['schedule_date'],    
        'description' => $row['purpose_description'] ?? '',
        'status' => $row['status'] ?? '',
    ];
}

echo json_encode($data);
?>
