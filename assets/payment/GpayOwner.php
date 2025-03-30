

<?php
require_once '../../assets/payment/vendor/autoload.php';
use GuzzleHttp\Client;

$view = $_GET['view'];
$result = $portCont->paymongo_configuration();
$client = new Client();

$email = $accounts['email'];

// Define success and fail URLs BEFORE sending the request
if($view == 'SPECIFICACCOUNTBOOK')
{
    $client_id = $_GET['client_id'];
    $success = "http://localhost/CLINIC_APP/account/admin/?view=".$view."&client_id=".$client_id."&message=success";
    $fail = "http://localhost/CLINIC_APP/account/admin/?view=".$view."&client_id=".$client_id."&message=failed";
}

else
{
    $success = "http://localhost/CLINIC_APP/account/admin/?view=".$view."&message=success";
    $fail = "http://localhost/CLINIC_APP/account/admin/?view=".$view."&message=failed";
}

try {
    $convertedPrice = (int)($accounts['amount'] * 100);

    // Send the request to PayMongo API to generate a link
    $response = $client->request('POST', 'https://api.paymongo.com/v1/sources', [
        'json' => [
            'data' => [
                'attributes' => [
                    'amount' => $convertedPrice,
                    'redirect' => [
                        'success' => $success,
                        'failed' => $fail
                    ],
                    'type' => 'gcash',
                    'currency' => 'PHP',
                ]
            ]
        ],
        'headers' => [
            'Accept' => 'application/json',
            'Authorization' => 'Basic ' . base64_encode($result[0]['pk_id']), // Secret key as username, no password
            'Content-Type' => 'application/json',
        ],
    ]);

    // Decode the response
    $responseData = json_decode($response->getBody(), true);

    if (isset($responseData['data']['id'])) {
        $sourceId = $responseData['data']['id'];
        $checkoutUrlGcash = $responseData['data']['attributes']['redirect']['checkout_url'];
        
    }

} catch (\GuzzleHttp\Exception\RequestException $e) {
    echo 'Request failed: ' . $e->getResponse()->getBody();
} catch (Exception $e) {
    echo 'Error: ' . $e->getMessage();
}
?>
