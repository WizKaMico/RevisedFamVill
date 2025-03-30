<?php
header('Content-Type: application/json');
include('../controller/chartsApiController.php');
$result = $portCont->ChartOverallTicket();
$data = [];

foreach ($result as $row) {
    $data[] = [
        'subject' => $row['subject'],
        'count' => (int)$row['count']
    ];
}

echo json_encode($data);
?>
