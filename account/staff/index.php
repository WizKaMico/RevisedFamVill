<?php 
include('../../connection/business_ownerStaffSession.php'); 
include('../../controller/userController.php'); 
$account = $portCont->myAccountStaff($user_id);
$account_id = $account[0]['account_id'];
$accountHeader = $portCont->checkTheme($account_id);
$accountSidebar = $portCont->checkSideBarTheme($account_id);
$notice = $portCont->myAccountAnnouncementDisplay($account_id);


if(!empty($_GET['action']))
{
  switch($_GET['action'])
  {

     case "APPOINTMENTSTATUSUPDATE":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $client_id = filter_input(INPUT_POST, "client_id", FILTER_SANITIZE_STRING);
            $aid = filter_input(INPUT_POST, "aid", FILTER_SANITIZE_STRING);
            $status = filter_input(INPUT_POST, "status", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($client_id) && !empty($aid) && !empty($status))
            {
                try
                {
                    $portCont->myAppointmentBookingStatusUpdate($account_id, $client_id, $aid, $status);
                    // $portCont->updateBookingStatusAfterPayment($aid);
                    header('Location:?view=SPECIFICACCOUNTBOOK&client_id=' . $client_id . '&message=success');
                    exit;
                }
                catch(Exception $e)
                {
                    header('Location:?view=SPECIFICACCOUNTBOOK&client_id=' . $client_id . '&message=failed');
                    exit;
                }
            }
        }
    break;
    case "ASSIGNDOCTOR":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $user_id = filter_input(INPUT_POST, "user_id", FILTER_SANITIZE_STRING);
            $aid = filter_input(INPUT_POST, "aid", FILTER_SANITIZE_STRING);    
            $client_id = filter_input(INPUT_POST, "client_id", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($user_id) && !empty($aid))
            {
                try
                {
                    $view = $_GET['view'];
                    $account_activity = "Assign Doctor to ".$view;
                    $portCont->account_activity_insert($account_id, $view, $account_activity);

                    $portCont->addDoctorAppointAccount($account_id,$user_id,$aid);
                    Header('Location:?view=SPECIFICACCOUNTBOOK&client_id='.$client_id.'message=success');
                }
                catch(Exception $e)
                {
                    Header('Location:?view=SPECIFICACCOUNTBOOK&client_id='.$client_id.'&message=failed');
                    exit;
                }
            }
        }
        break;
    case "ADDINGOFDIAGNOSIS":
        if(isset($_POST['submit']))
        {
            $aid = filter_input(INPUT_POST, "aid", FILTER_SANITIZE_STRING);    
            $diagnosis = filter_input(INPUT_POST, "diagnosis", FILTER_SANITIZE_STRING);
            $client_id = filter_input(INPUT_POST, "client_id", FILTER_SANITIZE_STRING);
            if(!empty($aid) && !empty($diagnosis) && !empty($client_id))
            {
                try
                {
                    $portCont->update_appointment_diagnosis($aid, $diagnosis);
                    Header('Location:?view=SPECIFICACCOUNTBOOKVIEW&aid='.$aid.'&client_id='.$client_id.'&message=success');
                    exit;
                }
                catch(Exception $e)
                {
                    Header('Location:?view=SPECIFICACCOUNTBOOKVIEW&aid='.$aid.'&client_id='.$client_id.'&message=failed');
                    exit;
                }
            }
        }
        break;
        case "CREATEPATIENT":
            if (isset($_POST['submit'])) {
                $account_id = $account[0]['account_id'];
                $fullname = filter_input(INPUT_POST, "fullname", FILTER_SANITIZE_STRING);
                $username = filter_input(INPUT_POST, "username", FILTER_SANITIZE_STRING);
                $email = filter_input(INPUT_POST, "email", FILTER_SANITIZE_STRING);
                $phone = filter_input(INPUT_POST, "phone", FILTER_SANITIZE_STRING);
                $password = filter_input(INPUT_POST, "password", FILTER_SANITIZE_STRING);
                if(!empty($account_id) && !empty($fullname) && !empty($username) && !empty($email) && !empty($phone) && !empty($password))
                {
                    try
                    {
                        $view = $_GET['view'];
                        $account_activity = "Create Patient on ".$view;
                        $portCont->account_activity_insert($account_id, $view, $account_activity);
                        $result = $portCont->validatedPatientExistence($email,$phone);
                        if(empty($result))
                        {
                            $portCont->createPatient($account_id,$fullname,$username,$email,$phone,$password);
                            Header('Location:?view=PATIENT&message=success');
                        }
                        else
                        {
                            Header('Location:?view=PATIENT&message=failed');
                            exit;    
                        }
                    }
                    catch(Exception $e)
                    {
                        Header('Location:?view=PATIENT&message=failed');
                        exit;
                    }  
                }
                else
                {
                    Header('Location:?view=PATIENT&message=failed');
                    exit;
                }
            }
        break;
        case "BOOK":
            if(isset($_POST['submit']))
            {
                $account_id = $account[0]['account_id']; 
                $client_id = filter_input(INPUT_POST, "client_id", FILTER_SANITIZE_STRING);
                $pid = date('ymd').'-'.rand(66666,99999);
                $fullname = filter_input(INPUT_POST, "fullname", FILTER_SANITIZE_STRING);
                $contact = filter_input(INPUT_POST, "contact", FILTER_SANITIZE_STRING);
                $dob = filter_input(INPUT_POST, "dob", FILTER_SANITIZE_STRING);
                $date_option = filter_input(INPUT_POST, "date_option", FILTER_SANITIZE_STRING);
                $doa = ($date_option == "today") ? filter_input(INPUT_POST, "doa1", FILTER_SANITIZE_STRING) : filter_input(INPUT_POST, "doa2", FILTER_SANITIZE_STRING);
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
    
                $user_id = filter_input(INPUT_POST, "user_id", FILTER_SANITIZE_STRING);
    
                if(!empty($account_id) && !empty($client_id) && !empty($pid) && !empty($fullname) && !empty($contact) && !empty($dob) && !empty($doa) && !empty($gender) && !empty($purpose) && !empty($purpose_description) && !empty($fromIns))
                {
                    try
                    {
                        $activity = 'ADD BOOKING '.$pid;
                        if($date_option == "today")
                        {
                            $result = $portCont->acceptBookingAdmin($account_id, $pid, $client_id, $dob, $age, $fullname, $purpose, $purpose_description, $gender, $doa, $fromIns, $user_id);
                        }
                        else
                        {
                            $result = $portCont->acceptBooking($account_id, $pid, $client_id, $dob, $age, $fullname, $purpose, $purpose_description, $gender, $doa, $fromIns);
                        }
                        $appointmentPatient = strtoupper($result[0]["fullname"]);
                        $appointmentSchedule = $result[0]["schedule_date"];
                        $appointmentStatus = $result[0]["status"];
                        $email = $result[0]["email"];
                        if(!empty($appointmentPatient) && !empty($appointmentSchedule) && !empty($appointmentStatus))
                        {
                            $business_name = $account[0]['business_name'];
                            $activity = "${appointmentStatus} BOOKING HAS BEEN ADDED FOR PATIENT : ${appointmentPatient} | SCHEDULE : ${appointmentSchedule}";
                            require("../../assets/mail/checkUpNotification.php");
                            header('Location: ?view=SPECIFICACCOUNTBOOK&client_id='.$client_id.'&message=success');
                            exit;
                        }
                    }
                    catch(Exception $e)
                    {
                        header('Location: ?view=SPECIFICACCOUNTBOOK&client_id='.$client_id.'&message=failed&1');
                    }
                }
                else
                {
                    header('Location: ?view=SPECIFICACCOUNTBOOK&client_id='.$client_id.'&message=failed&2');
                }
    
            }
        break;
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
        case "ADDFOLLOWUP":
            if(isset($_POST["submit"])) {
                $account_id = $account[0]['account_id'];   
                $aid = filter_input(INPUT_POST, "aid", FILTER_SANITIZE_STRING);
                $doctor_id = filter_input(INPUT_POST, "user_id", FILTER_SANITIZE_STRING);
                $schedule_date = filter_input(INPUT_POST, "schedule_date", FILTER_SANITIZE_STRING); 
                $client_id = filter_input(INPUT_POST, "client_id", FILTER_SANITIZE_STRING); 
                if(!empty($account_id) && !empty($aid) && !empty($doctor_id) && !empty($schedule_date) && !empty($client_id))
                {
                    try
                    {
                        $portCont->addFollowUpSchedule($aid,$account_id,$doctor_id,$schedule_date);
                        header('Location: ?view=SPECIFICACCOUNTBOOKVIEW&aid='.$aid.'&client_id='.$client_id.'message=success');
                        exit;
                        
                    }
                    catch(Exception $e)
                    {
                        header('Location: ?view=SPECIFICACCOUNTBOOKVIEW&aid='.$aid.'&client_id='.$client_id.'message=failed');
                        exit;
                    }
                }
            }
        break;
        case "UPDATEFOLLOWUPAPPOINTMENTSCHEDULE":
            if(isset($_POST["submit"])) {
                $account_id = $account[0]['account_id']; 
                $fid = filter_input(INPUT_POST, "fid", FILTER_SANITIZE_STRING);
                $schedule_date = filter_input(INPUT_POST, "schedule_date", FILTER_SANITIZE_STRING); 
                $aid = filter_input(INPUT_POST, "aid", FILTER_SANITIZE_STRING);
                $client_id = filter_input(INPUT_POST, "client_id", FILTER_SANITIZE_STRING); 
                if(!empty($account_id) && !empty($fid) && !empty($schedule_date) && !empty($aid) && !empty($client_id))
                {
                    try
                    {
                        $portCont->updateFollowUpSchedule($account_id,$fid,$schedule_date);
                        header('Location: ?view=SPECIFICACCOUNTBOOKVIEW&aid='.$aid.'&client_id='.$client_id.'message=success');
                        exit;
                        
                    }
                    catch(Exception $e)
                    {
                        header('Location: ?view=SPECIFICACCOUNTBOOKVIEW&aid='.$aid.'&client_id='.$client_id.'message=failed');
                        exit;
                    }
                }
           }
        break;
        case "UPDATEFOLLOWUPAPPOINTMENTDIAGNOSIS":
            if(isset($_POST["submit"])) {
                $account_id = $account[0]['account_id']; 
                $fid = filter_input(INPUT_POST, "fid", FILTER_SANITIZE_STRING);
                $diagnosis = filter_input(INPUT_POST, "diagnosis", FILTER_SANITIZE_STRING); 
                $aid = filter_input(INPUT_POST, "aid", FILTER_SANITIZE_STRING);
                $client_id = filter_input(INPUT_POST, "client_id", FILTER_SANITIZE_STRING); 
                if(!empty($account_id) && !empty($fid) && !empty($diagnosis) && !empty($aid) && !empty($client_id))
                {
                    try
                    {
                        $portCont->updateFollowUpDiagnosis($account_id,$fid,$diagnosis);
                        header('Location: ?view=SPECIFICACCOUNTBOOKVIEW&aid='.$aid.'&client_id='.$client_id.'message=success');
                        exit;
                        
                    }
                    catch(Exception $e)
                    {
                        header('Location: ?view=SPECIFICACCOUNTBOOKVIEW&aid='.$aid.'&client_id='.$client_id.'message=failed');
                        exit;
                    }
                }
            }
        break;
        case "UPDATEFOLLOWUPAPPOINTMENTSTATUS":
            if(isset($_POST["submit"])) {
                $account_id = $account[0]['account_id']; 
                $fid = filter_input(INPUT_POST, "fid", FILTER_SANITIZE_STRING);
                $status = filter_input(INPUT_POST, "status", FILTER_SANITIZE_STRING); 
                $aid = filter_input(INPUT_POST, "aid", FILTER_SANITIZE_STRING);
                $client_id = filter_input(INPUT_POST, "client_id", FILTER_SANITIZE_STRING); 
                if(!empty($account_id) && !empty($fid) && !empty($status) && !empty($aid) && !empty($client_id))
                {
                    try
                    {
                        $portCont->updateFollowUpStatus($account_id,$fid,$status);
                        header('Location: ?view=SPECIFICACCOUNTBOOKVIEW&aid='.$aid.'&client_id='.$client_id.'message=success');
                        exit;
                        
                    }
                    catch(Exception $e)
                    {
                        header('Location: ?view=SPECIFICACCOUNTBOOKVIEW&aid='.$aid.'&client_id='.$client_id.'message=failed');
                        exit;
                    }
                }
            }
        break;

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
    <?php include('../../assets/alert/adminSwal.php'); ?>
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
        <title><?php echo strtoupper($account[0]['business_name']); ?> | Online Clinic System</title>
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
        <?php include('../../assets/alert/adminSwal.php'); ?>
    </head>

    <body>
        <div class="app-container app-theme-white body-tabs-shadow fixed-sidebar fixed-header">
            <?php include('../../route/account/staff/header/header.php'); ?>
            <div class="app-main">
                <?php include('../../route/account/staff/sidebar/sidebar.php'); ?>
                <div class="app-main__outer">
                    <div class="app-main__inner">
                        <?php 
                        $view = $_GET['view'];
                            switch($view)
                            {
                                case "HOME":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insertStaff($account_id, $user_id, $view, $account_activity);
                                    include('../../route/account/staff/dashboard.php');
                                    break;
                                case "PATIENT":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insertStaff($account_id, $user_id, $view, $account_activity);
                                    include('../../route/account/staff/patient.php');
                                    break;
                                case "DOCSERVE":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insertStaff($account_id, $user_id, $view, $account_activity);
                                    include('../../route/account/staff/doctor.php');
                                    break;
                                case "SCHEDULING":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insertStaff($account_id, $user_id, $view, $account_activity);
                                    include('../../route/account/staff/schedule.php');
                                    break;
                                case "REPORTS":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insertStaff($account_id, $user_id, $view, $account_activity);
                                    include('../../route/account/staff/reports.php');
                                    break;
                                case "SPECIFICACCOUNTBOOK":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insertStaff($account_id, $user_id, $view, $account_activity);
                                    include('../../route/account/staff/specificaccountbooking.php');
                                    break;
                                case "SPECIFICACCOUNTBOOKVIEW":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insertStaff($account_id, $user_id, $view, $account_activity);
                                    include('../../route/account/staff/specificaccountbookedview.php');
                                    break;
                                case "MYACCOUNT":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insertStaff($account_id, $user_id, $view, $account_activity);
                                    include('../../route/account/staff/account.php');
                                    break;
                                default:
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insertStaff($account_id, $user_id, $view, $account_activity);
                                    include('../../route/account/staff/404.php');
                                    break;
                            } 
                        ?>
                    </div>
                    <?php include('../../route/account/staff/footer/footer.php'); ?>
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
                case 'PATIENT':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'SPECIFICACCOUNTBOOK':
                    loadScript('../../assets/js/dt.js');
                    loadScript('../../assets/js/ap.js');
                    break;
                case 'SPECIFICACCOUNTBOOKVIEW':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'MYACCOUNT':
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