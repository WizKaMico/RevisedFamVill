<?php
header('Content-Type: application/json');
include('../controller/chartsApiController.php');
$result = $portCont->ChartOverallBusiness();
$data = [];

foreach ($result as $row) {
    $data[] = [
        'status' => $row['status'],
        'count' => (int)$row['count']
    ];
}

echo json_encode($data);
?>
