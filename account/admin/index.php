<?php 
include('../../connection/business_ownerSession.php'); 
include('../../controller/userController.php'); 
$account = $portCont->myAccount($account_id); 

$accountHeader = $portCont->checkTheme($account_id);
$accountSidebar = $portCont->checkSideBarTheme($account_id);

//TODAY
$profit = $portCont->profitChartToday($account_id);
$appointment = $portCont->appointmentChartToday($account_id);
$accounts_chart = $portCont->appointmentChartTodayBar($account_id);
$inquiry = $portCont->accountChartToday($account_id);
//TODAY

// OVERALL

$profitOverall = $portCont->profitChartOverall($account_id);
$appointmentOverall = $portCont->appointmentChartOverall($account_id);
$accounts_chart_overall = $portCont->accountChartOverall($account_id);
$inquiryOverall = $portCont->appointmentChartBarOverall($account_id);

// OVERALL


if(!empty($_GET['action']))
{
  switch($_GET['action'])
  {
     case "CREATEROLE":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $role_name = filter_input(INPUT_POST, "role_name", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($role_name))
            {
                try
                {
                    $portCont->createRoles($account_id,$role_name);
                    Header('Location:?view=ACCOUNTS&message=success');

                }
                catch(Exception $e)
                {
                    Header('Location:?view=ACCOUNTS&message=failed');
                    exit;
                }
            }
        }
        break;
    // ACCOUNTS

    case "CREATESERVICEROLE":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $role =  filter_input(INPUT_POST, "role", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($role))
            {
                try
                {
                    $view = $_GET['view'];
                    $account_activity = "Created Service Role to ".$view;
                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                    $portCont->createServiceAccount($account_id,$role);
                    Header('Location:?view=ACCOUNTS&message=success');
                }
                catch(Exception $e)
                {
                    Header('Location:?view=ACCOUNTS&message=failed');
                    exit;
                }
            }
        }
        break;
    case "DELETESERVICEROLE":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $sid =  filter_input(INPUT_POST, "sid", FILTER_SANITIZE_STRING);    
            if(!empty($account_id) && !empty($sid))
            {
                try
                {
                    $view = $_GET['view'];
                    $account_activity = "Deleted Service Role to ".$view;
                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                    $portCont->deleteServiceAccount($account_id,$sid);
                    Header('Location:?view=ACCOUNTS&message=success');
                }
                catch(Exception $e)
                {
                    Header('Location:?view=ACCOUNTS&message=failed');
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
    case "CREATEACCOUNT":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $fullname =  filter_input(INPUT_POST, "fullname", FILTER_SANITIZE_STRING);
            $email =  filter_input(INPUT_POST, "email", FILTER_SANITIZE_STRING);
            $phone =  filter_input(INPUT_POST, "phone", FILTER_SANITIZE_STRING);
            $password =  filter_input(INPUT_POST, "password", FILTER_SANITIZE_STRING);
            $role =  filter_input(INPUT_POST, "role", FILTER_SANITIZE_STRING);
            if(!empty($fullname) && !empty($email) && !empty($phone) && !empty($password) && !empty($role))
            {
                try
                {
                    $view = $_GET['view'];
                    $account_activity = "Created New Account to ".$view;
                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                    $portCont->createAccount($account_id,$fullname,$email,$phone,$password,$role);
                    Header('Location:?view=ACCOUNTS&message=success');
                }
                catch(Exception $e)
                {
                    Header('Location:?view=ACCOUNTS&message=failed');
                    exit;
                }
            }
        }
        break;
    case "UPDATEACCOUNTS":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $user_id =  filter_input(INPUT_POST, "user_id", FILTER_SANITIZE_STRING);
            $fullname =  filter_input(INPUT_POST, "fullname", FILTER_SANITIZE_STRING);
            $email =  filter_input(INPUT_POST, "email", FILTER_SANITIZE_STRING);
            $phone =  filter_input(INPUT_POST, "phone", FILTER_SANITIZE_STRING);
            $password =  filter_input(INPUT_POST, "password", FILTER_SANITIZE_STRING);
            $role =  filter_input(INPUT_POST, "role", FILTER_SANITIZE_STRING);
            if(!empty($user_id) && !empty($fullname) && !empty($email) && !empty($phone) && !empty($password) && !empty($role))
            {
                try
                {
                    $view = $_GET['view'];
                    $account_activity = "Update Accounts to ".$view;
                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                    $portCont->updateAccount($user_id,$account_id,$fullname,$email,$phone,$password,$role);
                    Header('Location:?view=ACCOUNTS&message=success');
                }
                catch(Exception $e)
                {
                    Header('Location:?view=ACCOUNTS&message=failed');
                    exit;
                }
            }
        }
        break;
    case "UPDATEACCOUNTSSTATUS":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $user_id =  filter_input(INPUT_POST, "user_id", FILTER_SANITIZE_STRING);
            $statusR =  filter_input(INPUT_POST, "status", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($user_id) && !empty($statusR))
            {   
                try
                {
                    $view = $_GET['view'];
                    $account_activity = "Verified/Unverified Accounts to ".$view;
                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                    $status = ($statusR == "UNVERIFIED") ? "VERIFIED" : "UNVERIFIED";
                    $portCont->updateAccountStatus($status,$user_id,$account_id);
                    Header('Location:?view=ACCOUNTS&message=success');
                }
                catch(Exception $e)
                {
                    Header('Location:?view=ACCOUNTS&message=failed');
                    exit;
                }
            }   
        }
     break;
     case "DELETEACCOUNT":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $user_id =  filter_input(INPUT_POST, "user_id", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($user_id))
            {   
                try
                {
                    $view = $_GET['view'];
                    $account_activity = "Delete Accounts to ".$view;
                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                    $portCont->deleteAccount($user_id,$account_id);
                    Header('Location:?view=ACCOUNTS&message=success');
                }
                catch(Exception $e)
                {
                    Header('Location:?view=ACCOUNTS&message=failed');
                    exit;
                }
            }   
        }
     break;
     case "ACCOUNTPAYGRADE":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $user_id =  filter_input(INPUT_POST, "user_id", FILTER_SANITIZE_STRING);
            $paygrade =  filter_input(INPUT_POST, "paygrade", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($user_id) && !empty($paygrade))
            {  
                try
                {
                    $view = $_GET['view'];
                    $account_activity = "Added Paygrade Accounts to ".$view;
                    $portCont->account_activity_insert($account_id, $view, $account_activity);

                    $result = $portCont->checkPayGradeAccount($user_id,$account_id);
                    if(!empty($result[0]['paygrade']))
                    {
                        $portCont->checkPayGradeAccountUpdate($user_id,$account_id,$paygrade);
                        Header('Location:?view=ACCOUNTS&message=success');
                    }
                    else
                    {
                        $portCont->checkPayGradeAccountInsert($user_id,$account_id,$paygrade);
                        Header('Location:?view=ACCOUNTS&message=success');
                    }
                }
                catch(Exception $e)
                {
                    Header('Location:?view=ACCOUNTS&message=failed');
                    exit;
                }
            }
        }
     break;
    // ACCOUNTS 
    //  INTEGRATION PART
     case "INTEGRATION":
        if(isset($_POST['submit']))
        {
          $account_id = $account[0]['account_id']; 
          $public_key = filter_input(INPUT_POST, "public_key", FILTER_SANITIZE_STRING);
          $secret_key = filter_input(INPUT_POST, "secret_key", FILTER_SANITIZE_STRING);
          $status = filter_input(INPUT_POST, "status", FILTER_SANITIZE_STRING);
          $mode = filter_input(INPUT_POST, "mode", FILTER_SANITIZE_STRING);
          if(!empty($account_id) && !empty($public_key) && !empty($secret_key) && !empty($status) && !empty($mode))
          {
            try
            { 
                $view = $_GET['view'];
                $account_activity = "Created New Integration to ".$view;
                $portCont->account_activity_insert($account_id, $view, $account_activity);
                $portCont->createAccountIntegrationPayment($account_id,$public_key,$secret_key,$status,$mode);
                Header('Location:?view=INTEGRATION&message=success');
            }
            catch(Exception $e)
            {
                Header('Location:?view=INTEGRATION&message=failed');
                exit;
            }  
          }
        }
        break;
     case "UPDATEINTEGRATION":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id'];
            $pid = filter_input(INPUT_POST, "pid", FILTER_SANITIZE_STRING);
            $public_key = filter_input(INPUT_POST, "public_key", FILTER_SANITIZE_STRING);
            $secret_key = filter_input(INPUT_POST, "secret_key", FILTER_SANITIZE_STRING);
            $status = filter_input(INPUT_POST, "status", FILTER_SANITIZE_STRING);
            $mode = filter_input(INPUT_POST, "mode", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($pid) && !empty($public_key) && !empty($secret_key) && !empty($status) && !empty($mode))
            {
                try
                {
                    $view = $_GET['view'];
                    $account_activity = "Updated Integration to ".$view;
                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                    $portCont->updateAccountIntegrationPayment($account_id,$pid,$public_key,$secret_key,$status,$mode);
                    Header('Location:?view=INTEGRATION&message=success');
                }
                catch(Exception $e)
                {
                    Header('Location:?view=INTEGRATION&message=failed');
                    exit;
                }  
            }
        }
        break;
        case "UPDATEINTEGRATIONSTATUS":
        if(isset($_POST['submit']))
        {    
            $account_id = $account[0]['account_id'];
            $pid = filter_input(INPUT_POST, "pid", FILTER_SANITIZE_STRING);
            $statusR = filter_input(INPUT_POST, "status", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($pid) && !empty($statusR))
            {
                try
                {
                    $view = $_GET['view'];
                    $account_activity = "Updated Status Integration on ".$view;
                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                    $status = ($statusR == "Active") ? "In-Active" : "Active";
                    $portCont->updateAccountIntegrationPaymentStatus($account_id,$pid,$status);
                    Header('Location:?view=INTEGRATION&message=success');
                }
                catch(Exception $e)
                {
                    Header('Location:?view=INTEGRATION&message=failed');
                    exit;
                }  
            }
        }
        break;
      case "DELETEINTEGRATION":
        if(isset($_POST['submit']))
        {   
            $account_id = $account[0]['account_id'];
            $pid = filter_input(INPUT_POST, "pid", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($pid))
            {
                try
                {
                    $view = $_GET['view'];
                    $account_activity = "Deleted Integration on ".$view;
                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                    $portCont->deleteAccountIntegrationPayment($account_id,$pid);
                    Header('Location:?view=INTEGRATION&message=success');
                }
                catch(Exception $e)
                {
                    Header('Location:?view=INTEGRATION&message=failed');
                    exit;
                }  
            }
        }
      break;
    // INTEGRATION PART

    // BILLING 

    case "PAYNOW":
        if(isset($_GET['action']))
        {
            $method = $_GET['method'];
            $trans_id = $_GET['trans_id'];
            $url = $_GET['url'];
            $code = $_GET['code'];
            $email = $_GET['email'];
            $account_type = $_GET['account_type'];
            if(!empty($method) && !empty($trans_id) && !empty($url) && !empty($code) && !empty($email) && !empty($account_type))
            {
                try
                {
                    $accountResult = $portCont->myBusinessAccountSubscription($method, $trans_id, $email, $code, $account_type);
                    Header('Location:'.$url);
                    exit;
                }
                catch(Exception $e)
                {
                    header('Location:?view=SUBSCRIPTIONPAYMENT&email=' . $email . '&message=failed');
                    exit;
                }
            }
        }
    break;


    // BILLING
    // SERVICE
    case "UPDATESERVICE":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $bsid = filter_input(INPUT_POST, "bsid", FILTER_SANITIZE_STRING);
            $service = filter_input(INPUT_POST, "service", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($bsid) && !empty($service))
            {
                try
                {
                    $view = $_GET['view'];
                    $account_activity = "Updated Service on ".$view;
                    $portCont->account_activity_insert($account_id, $view, $account_activity);

                    $portCont->updateAccountService($account_id,$bsid,$service);
                    Header('Location:?view=SERVICE&message=success');
                }
                catch(Exception $e)
                {
                    Header('Location:?view=SERVICE&message=failed');
                    exit;
                }  
            }
        }
        break;
    case "DELETESERVICE":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $bsid = filter_input(INPUT_POST, "bsid", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($bsid))
            {
                try
                {
                    $view = $_GET['view'];
                    $account_activity = "Deleted Service on ".$view;
                    $portCont->account_activity_insert($account_id, $view, $account_activity);

                    $portCont->deleteAccountService($account_id,$bsid);
                    Header('Location:?view=SERVICE&message=success');
                }
                catch(Exception $e)
                {
                    Header('Location:?view=SERVICE&message=failed');
                    exit;
                }  
            }
        }
        break;
    case "SERVICE":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $service = filter_input(INPUT_POST, "service", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($service))
            {
                try
                {
                    $view = $_GET['view'];
                    $account_activity = "Created Service on ".$view;
                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                    $portCont->createAccountService($account_id,$service);
                    Header('Location:?view=SERVICE&message=success');
                }
                catch(Exception $e)
                {
                    Header('Location:?view=SERVICE&message=failed');
                    exit;
                }  
            }
        }
        break;
    // SERVICE

    // PATIENT
    case "UPDATEPATIENT":
       if (isset($_POST['submit'])) {
            $account_id = $account[0]['account_id'];
            $client_id = filter_input(INPUT_POST, "client_id", FILTER_SANITIZE_STRING);
            $fullname = filter_input(INPUT_POST, "fullname", FILTER_SANITIZE_STRING);
            $username = filter_input(INPUT_POST, "username", FILTER_SANITIZE_STRING);
            $email = filter_input(INPUT_POST, "email", FILTER_SANITIZE_STRING);
            $phone = filter_input(INPUT_POST, "phone", FILTER_SANITIZE_STRING);
            $password = filter_input(INPUT_POST, "password", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($client_id) && !empty($fullname) && !empty($username) && !empty($email) && !empty($phone) && !empty($password))
            {
                try
                {
                    $view = $_GET['view'];
                    $account_activity = "Updated Patient on ".$view;
                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                    $portCont->updatePatient($account_id,$client_id,$fullname,$username,$email,$phone,$password);
                    Header('Location:?view=PATIENT&message=success');
                }
                catch(Exception $e)
                {
                    Header('Location:?view=PATIENT&message=failed');
                    exit;
                }  
            }
        }
      break;
    case "DELETEPATIENT":
        if (isset($_POST['submit'])) {
            $account_id = $account[0]['account_id'];
            $client_id = filter_input(INPUT_POST, "client_id", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($client_id))
            {
                try
                {
                    $view = $_GET['view'];
                    $account_activity = "Delete Patient on ".$view;
                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                    $portCont->deletePatient($account_id,$client_id);
                    Header('Location:?view=PATIENT&message=success');
                }
                catch(Exception $e)
                {
                    Header('Location:?view=PATIENT&message=failed');
                    exit;
                }  
            }
        }
    break;
    case "ACTIVATEDEACTIVATEPATIENT":
        if (isset($_POST['submit'])) {
            $account_id = $account[0]['account_id'];
            $client_id = filter_input(INPUT_POST, "client_id", FILTER_SANITIZE_STRING);
            $statusR = filter_input(INPUT_POST, "status", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($client_id) && !empty($statusR))
            {
                try
                {
                    $view = $_GET['view'];
                    $account_activity = "Updated Status Integration on ".$view;
                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                    $status = ($statusR == "UNVERIFIED") ? "VERIFIED" : "UNVERIFIED";
                    $portCont->updatePatientStatus($account_id,$client_id,$status);
                    Header('Location:?view=PATIENT&message=success');
                }
                catch(Exception $e)
                {
                    Header('Location:?view=PATIENT&message=failed');
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

    case "PAYNOWAPPOINTMENTBILL":
        if(isset($_GET['action']))
        {
            $account_id = $account[0]['account_id']; 
            $aid = $_GET['aid'];
            $client_id = $_GET['client_id'];
            $method = $_GET['method'];
            $trans_id = $_GET['trans_id'];
            $url = $_GET['url'];
            $code = $_GET['code'];
            $email = $_GET['email'];
          if($method != "cash_payment")
          {
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
                    header('Location:?view=SPECIFICACCOUNTBOOK&client_id=' . $client_id . '&message=failed');
                    exit;
                }
            }
          }
          else
          {
            if(!empty($account_id) && !empty($aid) && !empty($client_id) && !empty($method) && !empty($code) && !empty($email))
            {
                try
                {
                    $trans_id = 0;
                    $url = 0;
                    $accountResult = $portCont->myAppointmentBookingPayment($account_id, $aid, $client_id, $method, $trans_id, $url, $code, $email);
                    $portCont->updateBookingStatusAfterPaymentCash($aid);
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
        }
    break;

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
    // PATIENT

    // ANNOUNCEMENT
    case "CREATEANNOUNCEMENT":
       if(isset($_POST['submit'])) {
        $account_id = $account[0]['account_id']; 
        $announcement_title = filter_input(INPUT_POST, "announcement_title", FILTER_SANITIZE_STRING);
        $announcement_content = filter_input(INPUT_POST, "announcement_content", FILTER_SANITIZE_STRING);
        $status = filter_input(INPUT_POST, "status", FILTER_SANITIZE_STRING);
        if(!empty($account_id) && !empty($announcement_title)  && !empty($announcement_content) && !empty($status))
        {
            try
            {
                $portCont->myAnnouncementCreation($account_id, $announcement_title, $announcement_content, $status);
                header('Location:?view=ANNOUNCEMENT&message=success');
                exit;
            }
            catch(Exception $e)
            {
                header('Location:?view=ANNOUNCEMENT&message=failed');
                exit;
            }
        }
       }
    break;

    case "UPDATEANNOUNCEMENT":
        if(isset($_POST['submit'])) {
            $account_id = $account[0]['account_id']; 
            $announcement_id = filter_input(INPUT_POST, "announcement_id", FILTER_SANITIZE_STRING);
            $announcement_title = filter_input(INPUT_POST, "announcement_title", FILTER_SANITIZE_STRING);
            $announcement_content = filter_input(INPUT_POST, "announcement_content", FILTER_SANITIZE_STRING);
            $status = filter_input(INPUT_POST, "status", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($announcement_id)  && !empty($announcement_title)  && !empty($announcement_content) && !empty($status))
            {
                try
                {
                    $portCont->myAnnouncementUpdate($account_id, $announcement_id, $announcement_title, $announcement_content, $status);
                    header('Location:?view=ANNOUNCEMENT&message=success');
                    exit;
                }
                catch(Exception $e)
                {
                    header('Location:?view=ANNOUNCEMENT&message=failed');
                    exit;
                }
            }
        }  
    break;
    case "DELETEANNOUNCEMENT":
        if(isset($_POST['submit'])) {
            $announcement_id = filter_input(INPUT_POST, "announcement_id", FILTER_SANITIZE_STRING);
            if(!empty($announcement_id))
            {
                try
                {
                    $portCont->myAnnouncementDelete($account_id);
                    header('Location:?view=ANNOUNCEMENT&message=success');
                    exit;
                }
                catch(Exception $e)
                {
                    header('Location:?view=ANNOUNCEMENT&message=failed');
                    exit;
                }
            }
        }
    break;
    // ANNOUNCEMENT
    case "PRODUCT":
        if (isset($_POST['submit'])) {
            $account_id = $account[0]['account_id']; 
            $name = filter_input(INPUT_POST, "name", FILTER_SANITIZE_STRING);
            $code = filter_input(INPUT_POST, "code", FILTER_SANITIZE_STRING);
            $price = filter_input(INPUT_POST, "price", FILTER_SANITIZE_STRING);
            $quantity = filter_input(INPUT_POST, "quantity", FILTER_SANITIZE_STRING);
            $status = filter_input(INPUT_POST, "status", FILTER_SANITIZE_STRING);
            
            if (!empty($name) && !empty($code) && !empty($price) && isset($_FILES['image']) && !empty($quantity) && !empty($status)) {
                $upload_dir = "uploads/"; 
            
                if (!is_dir($upload_dir)) {
                    mkdir($upload_dir, 0777, true); 
                }
    
                $file_name = basename($_FILES['image']['name']);
                $target_file = $upload_dir . time() . "_" . $file_name;
                $file_type = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));
    
              
                $allowed_types = ['pdf', 'doc', 'docx', 'jpg', 'png', 'jpeg'];
    
              
                if (in_array($file_type, $allowed_types)) {
                    if (move_uploaded_file($_FILES['image']['tmp_name'], $target_file)) {
                        try {
                            
                            $accountResult = $portCont->myBusinessAccountProduct($account_id, $name, $code, $target_file, $price, $quantity, $status);
                            header('Location:?view=PRODUCT&message=success');
                            exit;
                        } catch (Exception $e) {
                            header('Location:?view=PRODUCT&message=failed1');
                            exit;
                        }
                    } else {
                        header('Location:?view=PRODUCT&message=failed2');
                        exit;
                    }
                } else {
                    header('Location:?view=PRODUCT&message=failed3');
                    exit;
                }
            } else {
                header('Location:?view=PRODUCT&message=failed4');
                exit;
            }
        }
        break;
    
    // TICKET

    case "CREATETICKET":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $level = filter_input(INPUT_POST, "level", FILTER_SANITIZE_STRING);
            $subject = filter_input(INPUT_POST, "subject", FILTER_SANITIZE_STRING);
            $concern = filter_input(INPUT_POST, "concern", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($level) && !empty($subject) && !empty($concern))
            {
                try
                {
                    $portCont->myBusinessSupportTicket($account_id, $level, $subject, $concern);
                    header('Location:?view=SUPPORT&message=success');
                    exit;
                }
                catch(Exception $e)
                {
                    header('Location:?view=SUPPORT&message=success');
                    exit;
                }
            }
        }
        break;

    case "UPDATESUPPORTTICKET":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $level = filter_input(INPUT_POST, "level", FILTER_SANITIZE_STRING);
            $ticketid = filter_input(INPUT_POST, "ticketid", FILTER_SANITIZE_STRING);
            $subject = filter_input(INPUT_POST, "subject", FILTER_SANITIZE_STRING);
            $concern = filter_input(INPUT_POST, "concern", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($level) && !empty($subject) && !empty($concern))
            {
                try
                {
                    $portCont->updatemyBusinessSupportTicket($account_id, $level, $ticketid, $subject, $concern);
                    header('Location:?view=SUPPORT&message=success');
                    exit;
                }
                catch(Exception $e)
                {
                    header('Location:?view=SUPPORT&message=success');
                    exit;
                }
            }
        }
        break;

    case "DELETESUPPORTTICKET":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $ticketid = filter_input(INPUT_POST, "ticketid", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($ticketid))
            {
                try
                {
                    $portCont->deletemyBusinessSupportTicket($account_id, $ticketid);
                    header('Location:?view=SUPPORT&message=success');
                    exit;
                }
                catch(Exception $e)
                {
                    header('Location:?view=SUPPORT&message=success');
                    exit;
                }
            }
        }
    break;

    case "CREATETICKETRESPONSE":
        if(isset($_POST['submit']))
        {
            $ticketid = filter_input(INPUT_POST, "ticketid", FILTER_SANITIZE_STRING);
            $response = filter_input(INPUT_POST, "response", FILTER_SANITIZE_STRING);
            if(!empty($ticketid) && !empty($response))
            {
                try
                {   
                    // viewTicketResponse($ticketid)
                    $portCont->createmyBusinessSupportTicketResponse($ticketid, $response);
                    header('Location:?view=SUPPORTSPECIFICRESPONSE&ticketid='.$ticketid.'&message=success');
                    exit;
                }
                catch(Exception $e)
                {
                    header('Location:?view=SUPPORTSPECIFICRESPONSE&ticketid='.$ticketid.'&message=failed');
                    exit;
                }
            }
        }
    break;
    // TICKET
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
        <title>Family Vill Clinic</title>
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

    <!-- Loader -->
        <div class="app-container app-theme-white body-tabs-shadow fixed-sidebar fixed-header">
            <?php include('../../route/account/admin/header/header.php'); ?>
            <?php include('../../route/account/admin/layout/layout.php'); ?>
            <div class="app-main">
                <?php include('../../route/account/admin/sidebar/sidebar.php'); ?>
                <div class="app-main__outer">
               
                    <div id="content" class="app-main__inner">
                        
                        <?php 
                        $view = $_GET['view'];
                            switch($view)
                            {
                                case "HOME":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/dashboard.php');
                                    break;
                                case "PATIENT":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/patient.php');
                                    break;
                                case "SPECIFICACCOUNTBOOK":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/specificaccountbooking.php');
                                    break;
                                case "SPECIFICACCOUNTBOOKVIEW":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/specificaccountbookedview.php');
                                    break;
                                case "SCHEDULING":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/scheduling.php');
                                    break;
                                case "SERVICE":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/services.php');
                                    break;
                                case "REPORTS":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/reports.php');
                                    break;
                                case "INQUIRY":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/inquiry.php');
                                    break;
                                case "ANNOUNCEMENT":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/announcement.php');
                                    break;
                                case "ACCOUNTS":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/accounts.php');
                                    break;
                                case "BILLING":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/billing.php');
                                    break;
                                case "INTEGRATION":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/integration.php');
                                    break;
                                case "MYACCOUNT":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/myaccount.php');
                                    break;
                                case "ACTIVITYLOGS":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/patientlogs.php');
                                    break;
                                case "STAFFLOGS":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/stafflogs.php');
                                    break;
                                case "SUPPORT":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/support.php');
                                    break;
                                case "SUPPORTSPECIFICRESPONSE":
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/supportspecific.php');
                                    break;
                                default:
                                    $account_activity = "Navigate to ".$view;
                                    $portCont->account_activity_insert($account_id, $view, $account_activity);
                                    include('../../route/account/admin/404.php');
                                    break;
                            } 
                        ?>
                    </div>
                    <?php include('../../route/account/admin/footer/footer.php'); ?>
                </div>
            </div>
        </div>
        <!-- Modal -->
        <?php include('../../assets/modal/generic_modal.php'); ?>
        <!-- Modal -->                    
        <script type="text/javascript"
            src="../../assets/script/main.js"></script>
        <script type="text/javascript" src="../../assets/js/loading.js"></script>
        <!-- partial -->
         <script>
        document.querySelectorAll(".switch-header-cs-class, .switch-sidebar-cs-class").forEach(item => {
                item.addEventListener("click", function() {
                let selectedClass = this.getAttribute("data-class");
                let accountId = "<?php echo $account_id; ?>"; // Ensure this is outputted correctly in PHP
                let apiUrl = ""; // This will change based on the class

                // Determine which API to call based on the class
                if (this.classList.contains("switch-header-cs-class")) {
                    apiUrl = "../../api/headerTheme.php"; // API for header theme
                } else if (this.classList.contains("switch-sidebar-cs-class")) {
                    apiUrl = "../../api/sidebarTheme.php"; // API for sidebar theme
                }

                console.log("Applying Theme:", selectedClass);
                console.log("Account ID:", accountId);
                console.log("API Endpoint:", apiUrl);

                // Send the selected theme and account ID to the correct backend API
                fetch(apiUrl, {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: "theme=" + encodeURIComponent(selectedClass) + "&account_id=" + encodeURIComponent(accountId)
                })
                .then(response => response.text())
                .then(data => console.log("Server Response:", data)) // Log response from PHP
                .catch(error => console.error("Error:", error));
            });
        });
        </script>


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
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script> 

        <script>
        <?php 
    
        $view = isset($_GET['view']) ? $_GET['view'] : 'default'; 

        ?>
        document.addEventListener("DOMContentLoaded", function() {
            const view = "<?php echo $view; ?>";
            const accountId = "<?php echo $account_id; ?>";
            switch (view) {


                case 'HOME':
                    
                    google.charts.load("current", { packages: ["corechart"] });
                    google.charts.setOnLoadCallback(() => {
                    drawPieChartToday();
                    drawBarChartToday();
                    drawPieChart2Today();
                    drawBarChart2Today();
                    });

                    // === First Pie Chart ===
                    function drawPieChartToday() {
                    fetch(`../../api/todaychartsApi.php?account_id=${accountId}`)
                        .then((response) => response.json())
                        .then((result) => {
                        const dataArray = [["Method", "Count"]];
                        result.forEach((item) => {
                            dataArray.push([item.method, item.count]);
                        });

                        const data = google.visualization.arrayToDataTable(dataArray);
                        const options = {
                            title: "Profit Count Per Method Today",
                            pieHole: 0.4,
                            legend: { position: "right" },
                            chartArea: { width: "80%", height: "80%" },
                        };

                        const chart = new google.visualization.PieChart(
                            document.getElementById("piechart1")
                        );
                        chart.draw(data, options);
                        })
                        .catch((error) =>
                        console.error("Error fetching first pie chart data:", error)
                        );
                    }

                    // === Bar Chart ===
                    function drawBarChartToday() {
                    fetch(`../../api/todaybarChartsApi.php?account_id=${accountId}`)
                        .then((response) => response.json())
                        .then((result) => {
                        const dataArray = [["Status", "Count", { role: "style" }]];
                        const colors = ["#4caf50", "#f44336", "#2196f3", "#ff9800"];

                        result.forEach((item, index) => {
                            dataArray.push([
                            item.status,
                            item.count,
                            colors[index % colors.length],
                            ]);
                        });

                        const data = google.visualization.arrayToDataTable(dataArray);
                        const options = {
                            title: "Appointment Count by Status Today",
                            chartArea: { width: "70%" },
                            hAxis: { title: "Total Count", minValue: 0 },
                            vAxis: { title: "Status" },
                            legend: { position: "none" },
                        };

                        const chart = new google.visualization.BarChart(
                            document.getElementById("barchart")
                        );
                        chart.draw(data, options);
                        })
                        .catch((error) => console.error("Error fetching bar chart data:", error));
                    }

                    // === Second Pie Chart (Accounts) ===
                    function drawPieChart2Today() {
                    fetch(`../../api/todaypieChartsApi.php?account_id=${accountId}`)
                        .then((response) => response.json())
                        .then((result) => {
                        const dataArray = [["Status", "Count"]];
                        result.forEach((item) => {
                            dataArray.push([item.status, item.count]);
                        });

                        const data = google.visualization.arrayToDataTable(dataArray);
                        const options = {
                            title: "Account Count Per Status Today",
                            pieHole: 0.4,
                            legend: { position: "right" },
                            chartArea: { width: "80%", height: "80%" },
                        };

                        const chart = new google.visualization.PieChart(
                            document.getElementById("piechart2")
                        );
                        chart.draw(data, options);
                        })
                        .catch((error) =>
                        console.error("Error fetching second pie chart data:", error)
                        );
                    }

                    // === Second Bar Chart (Inquiry) ===
                    function drawBarChart2Today() {
                    fetch(`../../api/todaybarChartsApiSecond.php?account_id=${accountId}`)
                        .then((response) => response.json())
                        .then((result) => {
                        const dataArray = [["Subject", "Count", { role: "style" }]];
                        const colors = ["#4caf50", "#f44336", "#2196f3", "#ff9800"];

                        result.forEach((item, index) => {
                            dataArray.push([
                            item.subject,
                            item.count,
                            colors[index % colors.length],
                            ]);
                        });

                        const data = google.visualization.arrayToDataTable(dataArray);
                        const options = {
                            title: "Inquiry Count Today",
                            chartArea: { width: "70%" },
                            hAxis: { title: "Total Count", minValue: 0 },
                            vAxis: { title: "Subject" },
                            legend: { position: "none" },
                        };

                        const chart = new google.visualization.BarChart(
                            document.getElementById("barchart2")
                        );
                        chart.draw(data, options);
                        })
                        .catch((error) =>
                        console.error("Error fetching second bar chart data:", error)
                        );
                    }

                    loadScript('../../assets/js/dt.js');

                    break;
                case 'ACCOUNTS':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'BILLING':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'INTEGRATION':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'SERVICE':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'PRODUCT':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'MYACCOUNT':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'SCHEDULING':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'PATIENT':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'INQUIRY':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'ANNOUNCEMENT':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'SPECIFICACCOUNTBOOK':
                    loadScript('../../assets/js/ap.js');
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'REPORTS':
                    
                    
                    google.charts.load("current", { packages: ["corechart"] });
                    google.charts.setOnLoadCallback(() => {
                    drawPieChart1Overall();
                    drawBarChartOverall();
                    drawPieChart2Overall();
                    drawBarChart2Overall();
                    });

                    // === First Pie Chart ===
                    function drawPieChart1Overall() {
                    fetch(`../../api/overallchartsApi.php?account_id=${accountId}`)
                        .then((response) => response.json())
                        .then((result) => {
                        const dataArray = [["Method", "Count"]];
                        result.forEach((item) => {
                            dataArray.push([item.method, item.count]);
                        });

                        const data = google.visualization.arrayToDataTable(dataArray);
                        const options = {
                            title: "Profit Count Per Method Today",
                            pieHole: 0.4,
                            legend: { position: "right" },
                            chartArea: { width: "80%", height: "80%" },
                        };

                        const chart = new google.visualization.PieChart(
                            document.getElementById("piechart1")
                        );

                        // Draw chart
                        chart.draw(data, options);

                        // === 🔥 Add event listener for legend clicks ===
                        google.visualization.events.addListener(chart, "select", function () {
                            const selection = chart.getSelection();
                            if (selection.length > 0) {
                            const selectedRow = selection[0].row;
                            const selectedMethod = data.getValue(selectedRow, 0); // Get method name
                            filterActivitySchedulingTable(selectedMethod);
                            }
                        });
                        })
                        .catch((error) =>
                        console.error("Error fetching first pie chart data:", error)
                        );
                    }


                    function filterActivitySchedulingTable(method) {
                    const table = $("#activityScheduling").DataTable();
                    table.search(method).draw(); // Filters rows based on method string
                    }



                    // === Bar Chart ===
                    function drawBarChartOverall() {
                    fetch(`../../api/overallbarChartsApi.php?account_id=${accountId}`)
                        .then((response) => response.json())
                        .then((result) => {
                        const dataArray = [["Status", "Count", { role: "style" }]];
                        const colors = ["#4caf50", "#f44336", "#2196f3", "#ff9800"];

                        result.forEach((item, index) => {
                            dataArray.push([
                            item.status,
                            item.count,
                            colors[index % colors.length],
                            ]);
                        });

                        const data = google.visualization.arrayToDataTable(dataArray);
                        const options = {
                            title: "Appointment Count by Status Today",
                            chartArea: { width: "70%" },
                            hAxis: { title: "Total Count", minValue: 0 },
                            vAxis: { title: "Status" },
                            legend: { position: "none" },
                        };

                        const chart = new google.visualization.BarChart(
                            document.getElementById("barchart")
                        );
                        chart.draw(data, options);
                        })
                        .catch((error) => console.error("Error fetching bar chart data:", error));
                    }

                    // === Second Pie Chart (Accounts) ===
                    function drawPieChart2Overall() {
                    fetch(`../../api/overallpieChartsApi.php?account_id=${accountId}`)
                        .then((response) => response.json())
                        .then((result) => {
                        const dataArray = [["Status", "Count"]];
                        result.forEach((item) => {
                            dataArray.push([item.status, item.count]);
                        });

                        const data = google.visualization.arrayToDataTable(dataArray);
                        const options = {
                            title: "Account Count Per Status Today",
                            pieHole: 0.4,
                            legend: { position: "right" },
                            chartArea: { width: "80%", height: "80%" },
                        };

                        const chart = new google.visualization.PieChart(
                            document.getElementById("piechart2")
                        );
                        chart.draw(data, options);
                        })
                        .catch((error) =>
                        console.error("Error fetching second pie chart data:", error)
                        );
                    }

                    // === Second Bar Chart (Inquiry) ===
                    function drawBarChart2Overall() {
                    fetch(`../../api/overallbarChartsApiSecond.php?account_id=${accountId}`)
                        .then((response) => response.json())
                        .then((result) => {
                        const dataArray = [["Subject", "Count", { role: "style" }]];
                        const colors = ["#4caf50", "#f44336", "#2196f3", "#ff9800"];

                        result.forEach((item, index) => {
                            dataArray.push([
                            item.subject,
                            item.count,
                            colors[index % colors.length],
                            ]);
                        });

                        const data = google.visualization.arrayToDataTable(dataArray);
                        const options = {
                            title: "Inquiry Count Today",
                            chartArea: { width: "70%" },
                            hAxis: { title: "Total Count", minValue: 0 },
                            vAxis: { title: "Subject" },
                            legend: { position: "none" },
                        };

                        const chart = new google.visualization.BarChart(
                            document.getElementById("barchart2")
                        );
                        chart.draw(data, options);
                        })
                        .catch((error) =>
                        console.error("Error fetching second bar chart data:", error)
                        );
                    }
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'SPECIFICACCOUNTBOOKVIEW':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'ACTIVITYLOGS':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'STAFFLOGS':
                    loadScript('../../assets/js/dt.js');    
                    break;
                case 'SUPPORT':
                    loadScript('../../assets/js/dt.js');
                    break;
                case 'SUPPORTSPECIFICRESPONSE':
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