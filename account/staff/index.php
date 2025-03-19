<?php 
include('../../connection/business_ownerStaffSession.php'); 
include('../../controller/userController.php'); 
$account = $portCont->myAccountStaff($user_id)
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

    </head>

    <body>
        <div class="app-container app-theme-white body-tabs-shadow fixed-sidebar fixed-header">
            <?php include('../../route/account/staff/header/header.php'); ?>
            <?php include('../../route/account/staff/layout/layout.php'); ?>
            <div class="app-main">
                <?php include('../../route/account/staff/sidebar/sidebar.php'); ?>
                <div class="app-main__outer">
                    <div class="app-main__inner">
                        <?php 
                        $view = $_GET['view'];
                            switch($view)
                            {
                                case "HOME":
                                    include('../../route/account/staff/dashboard.php');
                                    break;
                                case "PATIENT":
                                    include('../../route/account/staff/patient.php');
                                    break;
                                case "DOCSERVE":
                                    include('../../route/account/staff/doctor.php');
                                    break;
                                case "SCHEDULING":
                                    include('../../route/account/staff/schedule.php');
                                    break;
                                case "REPORTS":
                                    include('../../route/account/staff/reports.php');
                                    break;
                                default:
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