<?php 
session_start();
include('../controller/clinicController.php'); 
//validate company
if(empty($_GET['company'])) {
  Header('Location:../?view=HOME');
}else{
    $business_name = $_GET['company'];
    $account = $portCont->myBusinessAccount($business_name);
    if(empty($account[0]['account_id']))
    {
        Header('Location:../?view=HOME');
    }
}
//validate company

if(!empty($_GET['action']))
{
  switch($_GET['action'])
  {
    case "REGISTER":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id'];
            $username = filter_input(INPUT_POST,"username",FILTER_SANITIZE_STRING);
            $email = filter_input(INPUT_POST,"email",FILTER_SANITIZE_EMAIL);
            $phone = filter_input(INPUT_POST,"phone",FILTER_SANITIZE_EMAIL); 
            $password = filter_input(INPUT_POST,"password",FILTER_SANITIZE_STRING);
            $fullname = filter_input(INPUT_POST,"fullname",FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($username) && !empty($email) && !empty($phone) && !empty($password) && !empty($fullname))
            {
                try
                {
                    $result = $portCont->aAddAccount($account_id, $fullname, $username, $email, $phone, $password);
                    $userCode = $result[0]["code"];
                    $userEmail = $result[0]["email"];
                    if(!empty($userCode) && !empty($userEmail))
                    {
                        // require("./connection/mail/verification.php");
                        header('Location:?company='.$account[0]['business_name'].'&view=VERIFICATION&email='.$userEmail.'&message=success');
                    }
                }
                catch(Exception $e)
                {
                    header('Location:?company='.$account[0]['business_name'].'&view=REGISTER&message=failed');
                }
            }

        }
    break;
    case "VERIFY":
        if(isset($_POST['submit']))
        {
           $code = filter_input(INPUT_POST,"code",FILTER_SANITIZE_STRING);
           $email = filter_input(INPUT_POST,"email",FILTER_SANITIZE_EMAIL);
           if(!empty($code) && !empty($email))
           {
               try
               {
                   $result = $portCont->lSearchAccountVerification($email,$code);
                   $resultEmail = $result[0]["email"];
                   if($result[0]['client_id'] > 0)
                   {
                       header('Location:?company='.$account[0]['business_name'].'&view=HOME&message=success&email='.$resultEmail);
                   }
                   else
                   {
                       header('Location:?company='.$account[0]['business_name'].'&view=VERIFICATION&email='.$email.'&message=failed');
                   }
               }
               catch(Exception $e)
               {
                   header('Location:?company='.$account[0]['business_name'].'&view=VERIFICATION&email='.$email.'&message=failed');
               }
           }
        }
       break;
    case "FORGOT":
        if(isset($_POST['submit'])) 
        {
           $email = filter_input(INPUT_POST,"email",FILTER_SANITIZE_EMAIL);
           if(!empty($email))
           {
              try
              {
                  $result = $portCont->lSearchAccount($email);
                  $emailAccount = $result[0]["email"];
                  $codeAccount = $result[0]["code"];
                  if($result[0]['client_id'] > 0)
                  {
                    if(!empty($emailAccount) && !empty($codeAccount))
                    {
                      //   require("./connection/mail/forgot.php");
                      header('Location:?company='.$account[0]['business_name'].'&view=NEWPASSWORD&email='.$email.'&message=success');
                    }
                  }
                  else
                  {
                    header('Location:?company='.$account[0]['business_name'].'&view=FORGOT&message=failed');   
                  }
              }
              catch(Exception $e)
              {
                  header('Location:?company='.$account[0]['business_name'].'&view=FORGOT&message=failed');
              }
           }
        }
    break;
    case "NEWPASSWORD":
        if(isset($_POST['submit'])) 
        {
           $email = filter_input(INPUT_POST,"email",FILTER_SANITIZE_EMAIL);
           $password = filter_input(INPUT_POST,"password",FILTER_SANITIZE_STRING);
           $code = filter_input(INPUT_POST,"code",FILTER_SANITIZE_STRING);   
           if(!empty($email) && !empty($password) && !empty($code))
           {
              try
              {
                  $result = $portCont->AccountNewPasswordUpdate($password, $email, $code);
                  $emailExist = $result[0]["email"]; 
                  $newPassword = $result[0]["unhashed"];
                  if($result[0]['client_id'] > 0)
                  {
                    if(!empty($emailExist) && !empty($newPassword))
                    {
                        //   require("./connection/mail/newPasswordConfirmation.php");
                        header('Location:?company='.$account[0]['business_name'].'&view=HOME&message=success&email='.$emailExist);
                    }
                  }
                  else
                  {
                    header('Location:?company='.$account[0]['business_name'].'&view=NEWPASSWORD&message=failed&email='.$email);   
                  }
              }
              catch(Exception $e)
              {
                  header('Location:?company='.$account[0]['business_name'].'&view=NEWPASSWORD&message=failed&email='.$email);   
              }
           }
        }
      break;
      case "INQUIRY":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id'];
            $name = filter_input(INPUT_POST,"name", FILTER_SANITIZE_STRING);
            $email = filter_input(INPUT_POST,"email", FILTER_SANITIZE_EMAIL);
            $subject = filter_input(INPUT_POST,"subject", FILTER_SANITIZE_STRING);
            $message = filter_input(INPUT_POST,"message", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($name) && !empty($email) && !empty($subject) && !empty($message))
            {
                try
                {
                    $result = $portCont->aAddInquiry($account_id, $name, $email, $subject, $message);
                    header('Location:?company='.$account[0]['business_name'].'&view=HOME&message=success');
                }
                catch(Exception $e)
                {
                    header('Location:?company='.$account[0]['business_name'].'&view=HOME&message=failed');
                }
            }
            else
            {
                header('Location:?company='.$account[0]['business_name'].'&view=HOME&message=failed');
            }
        }
      break;
      case "LOGIN":
        if(isset($_POST['submit'])) 
         {
            $username = filter_input(INPUT_POST,"username",FILTER_SANITIZE_STRING);
            $password = md5(filter_input(INPUT_POST,"password",FILTER_SANITIZE_STRING));
            if(!empty($username) && !empty($password))
            {
               try
               {   
                   $result = $portCont->lSearchAccountLogin($username, $password);
                   $accounUid = $result[0]["client_id"];
                   if($result[0]['client_id'] > 0)
                   {
                     if(!empty($accounUid))
                     {
                        $_SESSION['client_id'] = $accounUid; 
                        $_SESSION['company'] = $account[0]['business_name'];
                        header('Location: ../account/patient/?company='.$account[0]['business_name'].'&view=HOME'); 
                        exit;
                     }
                   }
                   else
                   {
                    header('Location:?company='.$account[0]['business_name'].'&view=LOGIN&message=failed');
                   }
               }
               catch(Exception $e)
               {
                   header('Location:?company='.$account[0]['business_name'].'&view=LOGIN&message=failed');
               }
            }
         }
       break;
       case "STAFFLOGIN":
        if(isset($_POST['submit'])) 
        {
           $email = filter_input(INPUT_POST,"email",FILTER_SANITIZE_STRING);
           $password = md5(filter_input(INPUT_POST,"password",FILTER_SANITIZE_STRING));
           if(!empty($email) && !empty($password))
           {
              try
              {   
                  $results = $portCont->lSearchAccountLoginStaff($email, $password);
                  $accounUid = $results[0]["user_id"];
                  if($results[0]['user_id'] > 0)
                  {
                    if(!empty($accounUid))
                    {
                       $_SESSION['user_id'] = $accounUid; 
                       $_SESSION['company'] = $account[0]['business_name'];
                       header('Location: ../account/staff/?company='.$account[0]['business_name'].'&view=HOME'); 
                       exit;
                    }
                  }
                  else
                  {
                   header('Location:?company='.$account[0]['business_name'].'&view=STAFFLOGIN&message=failed1');
                  }
              }
              catch(Exception $e)
              {
                  header('Location:?company='.$account[0]['business_name'].'&view=STAFFLOGIN&message=failed2');
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
    <title><?php echo strtoupper($account[0]['business_name']); ?> | Online Clinic System | OCS</title>
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
    <link href="../assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="../assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="../assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="../assets/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
    <link href="../assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
    <link href="../assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">

    <!-- Main CSS File -->
    <link href="../assets/css/main.css" rel="stylesheet">
    <?php  include('../assets/alert/genericSwal.php'); ?>
    <!-- =======================================================
  * Template Name: Online Clinic System | OCS
  * Updated: Nov 13, 2024
  * Author: GMF
  ======================================================== -->
</head>

<body class="index-page">

    <header id="header" class="header sticky-top">
        <?php include('../route/clinic/upperheader/upperheader.php'); ?>
        <?php include('../route/clinic/navbar/navbar.php'); ?>
    </header>

    <main class="main">
        <?php if(!empty($_GET['view'])) { ?>
        <?php 
            switch($_GET['view']){
                case "HOME": 
                    include('../route/clinic/content/home.php');
                    break;
                case "LOGIN":
                    include('../route/clinic/content/login.php');
                    break;
                case "STAFFLOGIN":
                    include('../route/clinic/content/stafflogin.php');
                    break;
                case "REGISTER":
                    include('../route/clinic/content/register.php');
                    break;  
                case "VERIFICATION":
                    include('../route/clinic/content/verification.php');
                    break; 
                case "FORGOT":
                    include('../route/clinic/content/forgot.php');
                    break;  
                case "NEWPASSWORD":
                    include('../route/clinic/content/newpassword.php');
                    break;  
                 default:
                    include('../route/clinic/content/home.php');
                    break;
            }
        ?>
        <?php } else { ?>
        <?php include('../route/clinic/content/home.php'); ?>
        <?php } ?>
    </main>

    <footer id="footer" class="footer light-background">
        <?php include('../route/clinic/footer/footer.php'); ?>
    </footer>

    <!-- Scroll Top -->
    <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i
            class="bi bi-arrow-up-short"></i></a>

    <!-- Preloader -->
    <div id="preloader"></div>

    <!-- Vendor JS Files -->
    <script src="../assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="../assets/vendor/php-email-form/validate.js"></script>
    <script src="../assets/vendor/aos/aos.js"></script>
    <script src="../assets/vendor/glightbox/js/glightbox.min.js"></script>
    <script src="../assets/vendor/purecounter/purecounter_vanilla.js"></script>
    <script src="../assets/vendor/swiper/swiper-bundle.min.js"></script>

    <!-- Main JS File -->
    <script src="../assets/js/main.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="../assets/js/ph-address-selector.js"></script>        
</body>

</html>