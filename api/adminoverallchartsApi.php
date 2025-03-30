<?php
header('Content-Type: application/json');
include('../controller/chartsApiController.php'); 
$result = $portCont->ChartOverallInquiry();
$data = [];

foreach ($result as $row) {
    $data[] = [
        'subject' => $row['subject'],
        'count' => (int)$row['count']
    ];
}

echo json_encode($data);
?>
