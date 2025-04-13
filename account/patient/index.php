<?php 
include('../../connection/business_ownerPatientSession.php'); 
include('../../controller/userController.php'); 
$account = $portCont->myAccountPatient($client_id);
$account_id = $account[0]['account_id'];
$accountHeader = $portCont->checkTheme($account_id);
$accountSidebar = $portCont->checkSideBarTheme($account_id);
$notice = $portCont->myAccountAnnouncementDisplay($account_id);

if(!empty($_GET['action']))
{
  switch($_GET['action'])
  {
    case "BOOK":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $client_id = $account[0]['client_id'];
            $pid = date('ymd').'-'.rand(66666,99999);
            $fullname = filter_input(INPUT_POST, "fullname", FILTER_SANITIZE_STRING);
            $contact = filter_input(INPUT_POST, "contact", FILTER_SANITIZE_STRING);
            $dob = filter_input(INPUT_POST, "dob", FILTER_SANITIZE_STRING);
            $doa = filter_input(INPUT_POST, "doa", FILTER_SANITIZE_STRING);
            $gender = filter_input(INPUT_POST, "gender", FILTER_SANITIZE_STRING);
            $purpose = filter_input(INPUT_POST, "purpose", FILTER_SANITIZE_STRING);
            $purpose_description = filter_input(INPUT_POST, "purpose_description", FILTER_SANITIZE_STRING);
            $fromIns = filter_input(INPUT_POST, "fromIns", FILTER_SANITIZE_STRING);
            
            function calculateAge($dob) {
                $dobDate = new DateTime($dob);
                $currentDate = new DateTime(); 
                $age = $dobDate->diff($currentDate)->y; 
                return $age;
            }

            $age = calculateAge($dob);

            if(!empty($account_id) && !empty($client_id) && !empty($pid) && !empty($fullname) && !empty($contact) && !empty($dob) && !empty($doa) && !empty($gender) && !empty($purpose) && !empty($purpose_description) && !empty($fromIns))
            {
                try
                {
                    $activity = 'ADD BOOKING '.$pid;
                    $result = $portCont->acceptBooking($account_id, $pid, $client_id, $dob, $age, $fullname, $purpose, $purpose_description, $gender, $doa, $fromIns);
                    $appointmentPatient = strtoupper($result[0]["fullname"]);
                    $appointmentSchedule = $result[0]["schedule_date"];
                    $appointmentStatus = $result[0]["status"];
                    if(!empty($appointmentPatient) && !empty($appointmentSchedule) && !empty($appointmentStatus))
                    {
                        $activity = "${appointmentStatus} BOOKING HAS BEEN ADDED FOR PATIENT : ${appointmentPatient} | SCHEDULE : ${appointmentSchedule}";
                        $email = $result[0]["email"];
                        require("../../assets/mail/checkUpNotification.php");
                        header('Location: ?view=BOOK&message=success');
                        exit;
                    }
                }
                catch(Exception $e)
                {
                    header('Location: ?view='.$view.'&message=failed');
                }
            }
            else
            {
                header('Location:?view=BOOK&message=failed');
            }  

        }
    break;
    case "ADD":
        if (! empty($_POST["quantity"])) {
            
            $account_id = $account[0]['account_id'];
            $productResult = $portCont->getProductByCode($_GET["code"]);
            $cartResult = $portCont->getCartItemByProduct($productResult[0]["id"], $client_id);

            if (! empty($cartResult)) {
                $newQuantity = $cartResult[0]["quantity"] + $_POST["quantity"];
                $portCont->updateCartQuantity($newQuantity, $cartResult[0]["id"]);
            } else {
                $portCont->addToCart($productResult[0]["id"], $_POST["quantity"], $client_id, $account_id);
            }
        }
    break;
    case "remove":
        $portCont->deleteCartItem($_GET["id"]);
        break;
    case "empty":
        $portCont->emptyCart($client_id);
        break;
    case "PAYPRODUCT":
        if(!empty($_POST["submit"])) {
            $account_id = $account[0]['account_id'];
            $name = $account[0]['fullname'];
            $email = $account[0]['email'];
            $phone = $account[0]['phone'];
            $item_price = filter_input(INPUT_POST, "item_price", FILTER_SANITIZE_STRING);
        }
        $order = 0;
        if (! empty ($account_id) && ! empty ($client_id) && ! empty ($name) && ! empty ($email) && ! empty ($phone) && !empty($item_price)) {
            // able to insert into database
            
            $order = $portCont->insertOrder($account_id, $client_id, $name, $email, $phone, $item_price);
            if(!empty($order)) {
                if (! empty($cartItem)) {
                    if (! empty($cartItem)) {
                        foreach ($cartItem as $item) {
                            $shoppingCart->insertOrderItem( $order, $item["id"], $item["price"], $item["quantity"]);
                        }
                    }
                }
            }
        }
        break;
        // DASHBOARD PAGE 
        case "UPDATEAPPOINTMENTSCHEDULE":
            if(isset($_POST["submit"])) {
                $account_id = $account[0]['account_id'];   
                $aid = filter_input(INPUT_POST, "aid", FILTER_SANITIZE_STRING);
                $schedule_date = filter_input(INPUT_POST, "schedule_date", FILTER_SANITIZE_STRING); 
                if(!empty($account_id) && !empty($aid) && !empty($schedule_date))
                {
                    try
                    {
                        $portCont->updateMyPatientAppointment($account_id,$aid,$schedule_date);
                        header('Location: ?view=HOME&message=success');
                        exit;
                        
                    }
                    catch(Exception $e)
                    {
                        header('Location: ?view=HOME&message=failed');
                        exit;
                    }
                }
                else
                {
                    header('Location: ?view=HOME&message=failed'.$account_id.''.$aid.''.$schedule_date);
                    exit;
                }
            }
        break;    
        case "UPDATEAPPOINTMENTINFORMATION":
            if(isset($_POST["submit"])) {
                $account_id = $account[0]['account_id'];   
                $aid = filter_input(INPUT_POST, "aid", FILTER_SANITIZE_STRING);
                $fullname = filter_input(INPUT_POST, "fullname", FILTER_SANITIZE_STRING); 
                $purpose = filter_input(INPUT_POST, "purpose", FILTER_SANITIZE_STRING); 
                $purpose_description = filter_input(INPUT_POST, "purpose_description", FILTER_SANITIZE_STRING); 
                $gender = filter_input(INPUT_POST, "gender", FILTER_SANITIZE_STRING); 
                if(!empty($account_id) && !empty($aid) && !empty($fullname) && !empty($purpose) && !empty($purpose_description) && !empty($gender))
                {
                    try
                    {
                        $portCont->updateMyPatientInformation($account_id,$aid,$fullname,$purpose,$purpose_description,$gender);
                        header('Location: ?view=HOME&message=success');
                        exit;
                        
                    }
                    catch(Exception $e)
                    {
                        header('Location: ?view=HOME&message=failed');
                        exit;
                    }
                }
            }
        break;
        case "DELETEAPPOINTMENTINFORMATION":
            if(isset($_POST["submit"])) {
                $account_id = $account[0]['account_id'];   
                $aid = filter_input(INPUT_POST, "aid", FILTER_SANITIZE_STRING);
                if(!empty($account_id) && !empty($aid))
                {
                    try
                    {
                        $portCont->deleteMyPatientInformationAppointment($account_id,$aid);
                        header('Location: ?view=HOME&message=success');
                        exit;
                        
                    }
                    catch(Exception $e)
                    {
                        header('Location: ?view=HOME&message=failed');
                        exit;
                    }
                }
            }
        break;
        case "PAYAPPOINTMENT":
            if(isset($_GET['action']))
            {
                $account_id = $account[0]['account_id']; 
                $aid = $_GET['aid'];
                $client_id = $account[0]['client_id'];
                $method = $_GET['method'];
                $trans_id = $_GET['trans_id'];
                $url = $_GET['url'];
                $code = $_GET['code'];
                $email = $_GET['email'];
                if(!empty($account_id) && !empty($aid) && !empty($client_id) && !empty($method) && !empty($trans_id) && !empty($url) && !empty($code) && !empty($email))
                {
                    try
                    {
                        $accountResult = $portCont->myAppointmentBookingPayment($account_id, $aid, $client_id, $method, $trans_id, $url, $code, $email);
                        $portCont->updateBookingStatusAfterPayment($aid);
                        Header('Location:'.$url);
                        exit;
                    }
                    catch(Exception $e)
                    {
                        header('Location:?view=HOME&client_id=' . $client_id . '&message=failed');
                        exit;
                    }
                }
            }
        break;

        case "FEEDBACK":
            if(isset($_POST['submit']))
            {
                $view = $_GET['view'];
                $account_id = $account[0]['account_id']; 
                $client_id = $account[0]['client_id'];
                $pid = filter_input(INPUT_POST, "pid", FILTER_SANITIZE_STRING);
                $rate = filter_input(INPUT_POST, "rate", FILTER_SANITIZE_STRING);
                $feedback = filter_input(INPUT_POST, "feedback", FILTER_SANITIZE_STRING);
                if(!empty($account_id) && !empty($pid) && !empty($rate) && !empty($feedback))
                {
                    try
                    {
                        $accountResult = $portCont->myAppointmentBookingFeedback($account_id, $client_id, $pid, $rate, $feedback);
                        header('Location: ?view='.$view.'&message=success');
                        exit;
                    }
                    catch(Exception $e)
                    {
                        header('Location: ?view='.$view.'&message=failed');
                        exit;
                    }
                }
            }
        break;
        // DASHBOARD PAGE
  }
}
?>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title><?php echo strtoupper($account[0]['business_name']); ?> | Online Clinic System</title>
    <meta name="description" content="">
    <meta name="keywords" content="">
    <link rel="stylesheet" href="../assets/css/style.css">
    
</head>

<body>
    <!-- partial:index.partial.html -->
    <!doctype html>
    <html lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta http-equiv="Content-Language" content="en">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><?php echo strtoupper($account[0]['business_name']); ?>  | Online Clinic System</title>
        <meta name="viewport"
            content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
        <meta name="description" content="This is an example dashboard created using build-in elements and components.">
        <meta name="msapplication-tap-highlight" content="no">
        <link href="https://demo.dashboardpack.com/architectui-html-free/main.css" rel="stylesheet">
        <!-- Include Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Include Flatpickr CSS -->
        <link href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css" rel="stylesheet">
        <link rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link href="../../assets/css/tab.css" rel="stylesheet">
        <?php include('../../assets/alert/patientSwal.php'); ?>
    </head>

    <body>
        <div class="app-container app-theme-white body-tabs-shadow fixed-sidebar fixed-header">
            <?php include('../../route/account/patient/header/header.php'); ?>
            <?php include('../../route/account/patient/layout/layout.php'); ?>
            <div class="app-main">
                <?php include('../../route/account/patient/sidebar/sidebar.php'); ?>
                <div class="app-main__outer">
                    <div class="app-main__inner">
                        <?php 
                        $view = $_GET['view'];
                            switch($view)
                            {
                                case "HOME":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insertPatient($account_id, $client_id, $view, $account_activity);
                                    include('../../route/account/patient/dashboard.php');
                                    break;
                                case "HISTORY":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insertPatient($account_id, $client_id, $view, $account_activity);
                                    include('../../route/account/patient/history.php');
                                    break;
                                case "BOOK":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insertPatient($account_id, $client_id, $view, $account_activity);
                                    include('../../route/account/patient/book.php');
                                    break;
                                case "PRODUCTS":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insertPatient($account_id, $client_id, $view, $account_activity);
                                    include('../../route/account/patient/product.php');
                                    break;
                                case "MYACCOUNT":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insertPatient($account_id, $client_id, $view, $account_activity);
                                    include('../../route/account/patient/account.php');
                                    break;
                                case "SPECIFICACCOUNTBOOKVIEW":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insertPatient($account_id, $client_id, $view, $account_activity);
                                    include('../../route/account/patient/specificaccountbookedview.php');
                                    break;
                                default:
                                    include('../../route/account/patient/404.php');
                                    break;
                            } 
                        ?>
                    </div>
                    <?php include('../../route/account/patient/footer/footer.php'); ?>
                </div>
                <script src="http://maps.google.com/maps/api/js?sensor=true"></script>
            </div>
        </div>
         <!-- Modal -->
         <?php include('../../assets/modal/generic_modal.php'); ?>
        <!-- Modal -->                       
        <script type="text/javascript"
            src="https://demo.dashboardpack.com/architectui-html-free/assets/scripts/main.js"></script>
        <!-- partial -->

        <!-- DataTables CSS for Bootstrap 5 -->
        <link rel="stylesheet" type="text/css"
            href="https://cdn.datatables.net/1.12.1/css/dataTables.bootstrap5.min.css">

        <!-- DataTables JavaScript for Bootstrap 5 -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.12.1/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.12.1/js/dataTables.bootstrap5.min.js"></script>


        <!-- Include Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Include Flatpickr JS -->
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
                            
        <script>
        <?php 
    
        $view = isset($_GET['view']) ? $_GET['view'] : 'default'; 

        ?>
        document.addEventListener("DOMContentLoaded", function() {
            const view = "<?php echo $view; ?>";
            switch (view) {
                case 'HOME':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'BOOK':
                    console.log('test')
                    loadScript('../../assets/js/ap.js');
                    break;
                case 'PRODUCTS':
                    console.log('test')
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'HISTORY':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'MYACCOUNT':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'SPECIFICACCOUNTBOOKVIEW':
                    loadScript('../../assets/js/dt.js');
                    break;
            }

        });

        function loadScript(src) {
            const script = document.createElement('script');
            script.src = src;
            document.head.appendChild(script);
        }
        </script>
        <!-- generate datatable on our table -->

    </body>

    </html>

</body>

</html>