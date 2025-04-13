<?php 
session_start();
include('./controller/webController.php'); 

if(!empty($_GET['action']))
{
  switch($_GET['action'])
  {
      case "REGISTER":
        if(isset($_POST['submit']))
        {
            $business = filter_input(INPUT_POST, "business_name", FILTER_SANITIZE_STRING);
            $email = filter_input(INPUT_POST, "email", FILTER_SANITIZE_STRING);
            $phone = filter_input(INPUT_POST, "phone", FILTER_SANITIZE_STRING);
            $region = filter_input(INPUT_POST, "region_text", FILTER_SANITIZE_STRING);
            $province = filter_input(INPUT_POST, "province_text", FILTER_SANITIZE_STRING);
            $city = filter_input(INPUT_POST, "city_text", FILTER_SANITIZE_STRING);
            $barangay = filter_input(INPUT_POST, "barangay_text", FILTER_SANITIZE_STRING);
            $street = filter_input(INPUT_POST, "street", FILTER_SANITIZE_STRING);
            if(!empty($business) && !empty($email) && !empty($phone) && !empty($region) && !empty($province) && !empty($city) && !empty($barangay) && !empty($street))
            {
                try
                {
                    $result = $portCont->createBusinessAccount($business, $email, $phone, $region, $province, $city, $barangay, $street);
                    if($result[0]['account_id'] > 0)
                    {
                        //add email here before going thru
                        $code = $result[0]['code'];
                        require('./assets/mail/verification.php');
                        Header('Location:?view=CREATEPASSWORD&email='.$result[0]['email']);
                        exit;
                    }
                    else
                    {
                        Header('Location:?view=REGISTER&message=failed');
                        exit;
                    }
                }
                catch(Exception $e)
                {
                    Header('Location:?view=REGISTER&message=failed');
                    exit;
                }
            }
        }
        break;
        case "ACCOUNTPASSWORD":
            if(isset($_POST['submit']))
            {
                $email = filter_input(INPUT_POST, "email", FILTER_SANITIZE_STRING);
                $code = filter_input(INPUT_POST, "code", FILTER_SANITIZE_STRING);
                $password = filter_input(INPUT_POST, "password", FILTER_SANITIZE_STRING);
                $hashed = md5($password);
                if(!empty($email) && !empty($code) && !empty($hashed) && !empty($password))
                {
                    try
                    {
                        $accountResult = $portCont->myBusinessAccount($email,$code,$hashed,$password);
                        if($accountResult[0]['account_id'] > 0)
                        {
                            require('assets/mail/newPasswordConfirmation.php');
                            Header('Location:?view=ACCOUNTTYPE&email='.$email); 
                            exit;
                        }
                        else
                        {
                            Header('Location:?view=CREATEPASSWORD&email='.$email.'&message=failed'); 
                            exit;
                        }
                    }
                    catch(Exception $e)
                    {
                        Header('Location:?view=CREATEPASSWORD&email='.$email.'&message=failed');  
                        exit;  
                    }
                }
            }   
        break;
        case "ACCOUNTTYPE":
            if (isset($_POST['submit'])) {
                $email = filter_input(INPUT_POST, "email", FILTER_SANITIZE_STRING);
                $business_ownership = filter_input(INPUT_POST, "business_ownership", FILTER_SANITIZE_STRING);
                $business_tin = filter_input(INPUT_POST, "business_tin", FILTER_SANITIZE_STRING);
                
                if (!empty($business_ownership) && !empty($business_tin) && isset($_FILES['business_cert'])) {
                    $upload_dir = "uploads/"; 
                
                    if (!is_dir($upload_dir)) {
                        mkdir($upload_dir, 0777, true); 
                    }
        
                    $file_name = basename($_FILES['business_cert']['name']);
                    $target_file = $upload_dir . time() . "_" . $file_name;
                    $file_type = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));
        
                  
                    $allowed_types = ['pdf', 'doc', 'docx', 'jpg', 'png', 'jpeg'];
        
                  
                    if (in_array($file_type, $allowed_types)) {
                        if (move_uploaded_file($_FILES['business_cert']['tmp_name'], $target_file)) {
                            try {
                                
                                $accountResult = $portCont->myBusinessAccountLegality($email, $business_ownership, $target_file, $business_tin);
                                header('Location:?view=SUBSCRIPTIONPAYMENT&email=' . $email);
                                exit;
                            } catch (Exception $e) {
                                header('Location:?view=ACCOUNTTYPE&email=' . $email . '&message=failed');
                                exit;
                            }
                        } else {
                            header('Location:?view=ACCOUNTTYPE&email=' . $email . '&message=failed');
                            exit;
                        }
                    } else {
                        header('Location:?view=ACCOUNTTYPE&email=' . $email . '&message=failed');
                        exit;
                    }
                } else {
                    header('Location:?view=ACCOUNTTYPE&email=' . $email . '&message=failed');
                    exit;
                }
            }
            break;
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
            case "PAYMENTCONFIRMATION":
             if(isset($_GET['code']))
             {
                $code = $_GET['code'];
                $message = $_GET['message'];
                $email = $_GET['email'];
                if(!empty($code) && !empty($message))
                {
                   try
                   {
                        if($message == "success")
                        {
                            $status = "PAYED";
                        }
                        else
                        {
                            $status = "FAILED";
                        }
                        
                        $accountResult = $portCont->myBusinessAccountSubscriptionPaymentValidation($code, $status, $email);
                        Header('Location:?view=PAYMENTCONFIRMATION&email='.$email.'&code='.$code.'&status='.$status);
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
            case "FORGOT":
              if(isset($_POST['submit']))
              {
                $email = filter_input(INPUT_POST, "email", FILTER_SANITIZE_STRING);
                if(!empty($email))
                {
                    try
                    {
                        $code = rand(6666,9999);
                        $accountResult = $portCont->myAccountRecovery($email,$code);
                        if($accountResult[0]['account_id'] > 0)
                        {
                            //ADD EMAIL SENDING HERE
                            Header('Location:?view=NEWPASSWORD&email='.$email);
                            exit;
                        }
                        else
                        {
                            header('Location:?view=FORGOT&email=' . $email . '&message=failed'); 
                            exit;    
                        }
                    }
                    catch(Exception $e)
                    {
                        header('Location:?view=FORGOT&email=' . $email . '&message=failed');
                        exit; 
                    }
                }
              }
            break;
            case "NEWPASSWORD":
                if(isset($_POST['submit']))
                {
                    $email = filter_input(INPUT_POST, "email", FILTER_SANITIZE_STRING);
                    $code = filter_input(INPUT_POST, "code", FILTER_SANITIZE_STRING);
                    $password = filter_input(INPUT_POST, "password", FILTER_SANITIZE_STRING);
                    $hashed = md5($password);
                    if(!empty($email) && !empty($code) && !empty($hashed) && !empty($password))
                    {
                        try
                        {
                            $accountResult = $portCont->myBusinessAccount($email,$code,$hashed,$password);
                            if($accountResult[0]['account_id'] > 0)
                            {
                                Header('Location:?view=HOME&email='.$email.'&status=sucess'); 
                                exit;
                            }
                            else
                            {
                                Header('Location:?view=NEWPASSWORD&email='.$email.'&message=failed'); 
                                exit;
                            }
                        }
                        catch(Exception $e)
                        {
                            Header('Location:?view=NEWPASSWORD&email='.$email.'&message=failed');  
                            exit;  
                        }
                    }
                }   
            break;
            case "CONTACTS":
                if(isset($_POST['submit']))
                {
                    $name = filter_input(INPUT_POST, "name", FILTER_SANITIZE_STRING);
                    $email = filter_input(INPUT_POST, "email", FILTER_SANITIZE_STRING);
                    $subject = filter_input(INPUT_POST, "subject", FILTER_SANITIZE_STRING);
                    $message = filter_input(INPUT_POST, "message", FILTER_SANITIZE_STRING);
                    if(!empty($name) && !empty($email) && !empty($subject) && !empty($message))
                    {
                        try
                        {
                            $accountResult = $portCont->myBusinessAccountInquiry($name,$email,$subject,$message);
                            Header('Location:?view=HOME&message=success');  
                        }
                        catch(Exception $e)
                        {
                            Header('Location:?view=HOME&message=failed');  
                            exit; 
                        }
                    }
                }
            break;
            case "LOGIN":
                if(isset($_POST['submit']))
                {
                    $email = filter_input(INPUT_POST, "email", FILTER_SANITIZE_STRING);
                    $password = md5(filter_input(INPUT_POST, "password", FILTER_SANITIZE_STRING));
                    if(!empty($email) && !empty($password))
                    {
                        try
                        {
                            $accountResult = $portCont->myBusinessAccountLogin($email,$password);
                            if($accountResult[0]['account_id'] > 0)
                            {
                                $status = $accountResult[0]["status"];
                                switch($status)
                                {
                                    case "CONFIRMED":
                                        Header('Location:?view=ACCOUNTTYPE&email='.$email);
                                        break;
                                    case "VERIFIED":
                                        Header('Location:?view=SUBSCRIPTIONPAYMENT&email='.$email);
                                        break;
                                    case "SUBSCRIBED":
                                        $_SESSION['account_id'] = $accountResult[0]["account_id"];
                                        Header('Location:./account/admin/?view=HOME');
                                        break;
                                }
                            }
                            else
                            {
                                Header('Location:?view=LOGIN&message=failed');  
                                exit; 
                            }
                        }
                        catch(Exception $e)
                        {
                            Header('Location:?view=LOGIN&message=failed');  
                            exit; 
                        }
                    }
                }   
            break;
            case "ADMINLOGIN":
                if(isset($_POST['submit']))
                {
                    $email = filter_input(INPUT_POST, "email", FILTER_SANITIZE_STRING);
                    $password = md5(filter_input(INPUT_POST, "password", FILTER_SANITIZE_STRING));
                    if(!empty($email) && !empty($password))
                    {
                        try
                        {
                            $accountResult = $portCont->myBusinessAccountLoginAdmin($email,$password);
                            if($accountResult[0]['admin_id'] > 0)
                            {
                      
                                $_SESSION['admin_id'] = $accountResult[0]["admin_id"];
                                Header('Location:./account/superadmin/?view=HOME');
                            }
                            else
                            {
                                Header('Location:?view=ADMINLOGIN&message=failed');  
                                exit; 
                            }
                        }
                        catch(Exception $e)
                        {
                            Header('Location:?view=ADMINLOGIN&message=failed');  
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
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Online Clinic System | OCS</title>
    <meta name="description" content="">
    <meta name="keywords" content="">

    <!-- Favicons -->
    <!-- <link href="assets/img/favicon.png" rel="icon">
    <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon"> -->

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
    <link
        href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Raleway:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap"
        rel="stylesheet">

    <!-- Vendor CSS Files -->
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="assets/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
    <link href="assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
    <link href="assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">

    <!-- Main CSS File -->
    <link href="assets/css/main.css" rel="stylesheet">
    <?php  include('./assets/alert/genericSwal.php'); ?>
    <!-- =======================================================
  * Template Name: Online Clinic System | OCS
  * Updated: Nov 13, 2024
  * Author: GMF
  ======================================================== -->
</head>

<body class="index-page">

    <header id="header" class="header sticky-top">
        <?php include('route/web/upperheader/upperheader.php'); ?>
        <?php include('route/web/navbar/navbar.php'); ?>
    </header>

    <main class="main">
        <?php if(!empty($_GET['view'])) { ?>
        <?php 
            switch($_GET['view']){
                case "HOME": 
                    include('route/web/content/home.php');
                    break;
                case "LOGIN":
                    include('route/web/content/login.php');
                    break;
                case "ADMINLOGIN":
                    include('route/web/content/admin_login.php');
                    break;
                case "REGISTER":
                    include('route/web/content/register.php');
                    break;  
                case "CREATEPASSWORD":
                    include('route/web/content/create_password.php');
                    break;
                case "ACCOUNTTYPE":
                    include('route/web/content/account_type.php');
                    break;
                case "SUBSCRIPTIONPAYMENT":
                    include('route/web/content/account_subscription.php');
                    break;
                case "PAYMENTCONFIRMATION":
                    include('route/web/content/account_payconfirmation.php');
                    break;
                case "VERIFICATION":
                    include('route/web/content/verification.php');
                    break; 
                case "FORGOT":
                    include('route/web/content/forgot.php');
                    break;  
                case "NEWPASSWORD":
                    include('route/web/content/newpassword.php');
                    break;  
                default:
                    include('route/web/content/home.php');
                    break;
            }
        ?>
        <?php } else { ?>
        <?php include('route/web/content/home.php'); ?>
        <?php } ?>
    </main>

    <footer id="footer" class="footer light-background">
        <?php include('route/web/footer/footer.php'); ?>
    </footer>

    <!-- Scroll Top -->
    <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i
            class="bi bi-arrow-up-short"></i></a>

    <!-- Preloader -->
    <div id="preloader"></div>

    <!-- Vendor JS Files -->
    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="assets/vendor/php-email-form/validate.js"></script>
    <script src="assets/vendor/aos/aos.js"></script>
    <script src="assets/vendor/glightbox/js/glightbox.min.js"></script>
    <script src="assets/vendor/purecounter/purecounter_vanilla.js"></script>
    <script src="assets/vendor/swiper/swiper-bundle.min.js"></script>

    <!-- Main JS File -->
    <script src="assets/js/main.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="./assets/js/ph-address-selector.js"></script>        
</body>

</html>