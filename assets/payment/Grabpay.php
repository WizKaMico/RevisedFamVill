<?php
require_once 'assets/payment/vendor/autoload.php';
use GuzzleHttp\Client;

$result = $portCont->paymongo_configuration();
$client = new Client();

$email = $_GET['email'];

// Define success and fail URLs BEFORE sending the request
$success = "http://localhost/CLINIC_APP/?view=PAYMENTCONFIRMATION&action=PAYMENTCONFIRMATION&code=$code&email=$email&message=success";
$fail = "http://localhost/CLINIC_APP/?view=PAYMENTCONFIRMATION&action=PAYMENTCONFIRMATION&code=$code&email=$email&message=failed";

try {
    $convertedPrice = (int)($accountType['amount'] * 100);

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
                    'type' => 'grab_pay',
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

        // Append transaction ID to success & fail URLs
       
       $checkoutUrlGrabPay = $responseData['data']['attributes']['redirect']['checkout_url'];
    }

} catch (\GuzzleHttp\Exception\RequestException $e) {
    echo 'Request failed: ' . $e->getResponse()->getBody();
} catch (Exception $e) {
    echo 'Error: ' . $e->getMessage();
}
?>
