<?php 
include('../../connection/business_ownerSession.php'); 
include('../../controller/userController.php'); 
$account = $portCont->myAccount($account_id); 

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
    case "SERVICE":
        if(isset($_POST['submit']))
        {
            $account_id = $account[0]['account_id']; 
            $service = filter_input(INPUT_POST, "service", FILTER_SANITIZE_STRING);
            if(!empty($account_id) && !empty($service))
            {
                try
                {
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

    </head>

    <body>
        <div class="app-container app-theme-white body-tabs-shadow fixed-sidebar fixed-header">
            <?php include('../../route/account/admin/header/header.php'); ?>
            <?php include('../../route/account/admin/layout/layout.php'); ?>
            <div class="app-main">
                <?php include('../../route/account/admin/sidebar/sidebar.php'); ?>
                <div class="app-main__outer">
                    <div class="app-main__inner">
                        <?php 
                        $view = $_GET['view'];
                            switch($view)
                            {
                                case "HOME":
                                    include('../../route/account/admin/dashboard.php');
                                    break;
                                case "PATIENT":
                                    include('../../route/account/admin/patient.php');
                                    break;
                                case "SCHEDULING":
                                    include('../../route/account/admin/scheduling.php');
                                    break;
                                case "PRODUCT":
                                    include('../../route/account/admin/product.php');
                                    break;
                                case "SERVICE":
                                    include('../../route/account/admin/services.php');
                                    break;
                                case "REPORTS":
                                    include('../../route/account/admin/reports.php');
                                    break;
                                case "ACCOUNTS":
                                    include('../../route/account/admin/accounts.php');
                                    break;
                                case "BILLING":
                                    include('../../route/account/admin/billing.php');
                                    break;
                                case "INTEGRATION":
                                    include('../../route/account/admin/integration.php');
                                    break;
                                case "MYACCOUNT":
                                    include('../../route/account/admin/myaccount.php');
                                    break;
                                default:
                                    include('../../route/account/admin/404.php');
                                    break;
                            } 
                        ?>
                    </div>
                    <?php include('../../route/account/admin/footer/footer.php'); ?>
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