<?php
header('Content-Type: application/json');
include('../controller/chartsApiController.php'); 
$result = $portCont->ChartOverallPay();
$data = [];

foreach ($result as $row) {
    $data[] = [
        'method' => $row['paymethod'],
        'count' => (int)$row['count']
    ];
}

echo json_encode($data);
?>
