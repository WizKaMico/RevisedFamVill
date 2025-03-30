<?php 
include('../../connection/admin_ownerSession.php'); 
include('../../controller/userController.php'); 
$account = $portCont->myAccountAdmin($admin_id); 

// PROFIT
$profit = $portCont->ChartOverallPay();
// TICKET
$ticket = $portCont->ChartOverallTicket(); 
// ACCOUNTS 
$subscription = $portCont->ChartOverallBusiness();
// INQUIRY 
$inquiry = $portCont->ChartOverallInquiry();

if(!empty($_GET['action']))
{
  switch($_GET['action'])
  {
    case "ACTIVATEDEACTIVATEBUSINESS":
        if(isset($_POST['submit']))
        {
            $account_id = filter_input(INPUT_POST, "account_id", FILTER_SANITIZE_STRING);
            if(!empty($account_id))
            {
                try
                {
                    $result = $portCont->myAccountBusinessCheck($account_id);
                    $status = (isset($result[0]['status']) && $result[0]['status'] == "SUBSCRIBED") ? "UNVERIFIED" : "SUBSCRIBED";
                    $portCont->myAccountBusinessAccountActivationDeactivation($account_id,$status);
                    header('Location: ?view=BUSINESS&message=success');
                }
                catch(Exception $e)
                {
                    header('Location: ?view=BUSINESS&message=failed');
                }
            }
        }
    break;
    case "CREATESERVICE":
        if(isset($_POST['submit']))
        {
            $account = filter_input(INPUT_POST, "account", FILTER_SANITIZE_STRING);
            $description = filter_input(INPUT_POST, "description", FILTER_SANITIZE_STRING);
            $amount = filter_input(INPUT_POST, "amount", FILTER_SANITIZE_STRING);
            if(!empty($account) && !empty($description) && !empty($amount))
            {
                try
                {
                    $portCont->myAccountBusinessCreationOfService($account,$description,$amount);
                    header('Location: ?view=SERVICE&message=success');
                }
                catch(Exception $e)
                {
                    header('Location: ?view=SERVICE&message=failed');
                }
            }
        }
    break;
    case "UPDATESERVICE":
        if(isset($_POST['submit']))
        {
            $account_type = filter_input(INPUT_POST, "account_type", FILTER_SANITIZE_STRING);
            $account = filter_input(INPUT_POST, "account", FILTER_SANITIZE_STRING);
            $description = filter_input(INPUT_POST, "description", FILTER_SANITIZE_STRING);
            $amount = filter_input(INPUT_POST, "amount", FILTER_SANITIZE_STRING);
            if(!empty($account_type) && !empty($account) && !empty($description) && !empty($amount))
            {
                try
                {
                    $portCont->myAccountBusinessCreationOfServiceUpdate($account_type,$account,$description,$amount);
                    header('Location: ?view=SERVICE&message=success');
                }
                catch(Exception $e)
                {
                    header('Location: ?view=SERVICE&message=failed');
                }
            }
        }
    break;
    case "DELETESERVICE":
        if(isset($_POST['submit']))
        {
            $account_type = filter_input(INPUT_POST, "account_type", FILTER_SANITIZE_STRING);
            if(!empty($account_type))
            {
                try
                {
                    $portCont->myAccountBusinessCreationOfServiceDelete($account_type);
                    header('Location: ?view=SERVICE&message=success');
                }
                catch(Exception $e)
                {
                    header('Location: ?view=SERVICE&message=failed');
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
    case "UPDATESUPPORTTICKET":
        if(isset($_POST['submit']))
        {

            $ticketid = filter_input(INPUT_POST, "ticketid", FILTER_SANITIZE_STRING);
            $level = filter_input(INPUT_POST, "level", FILTER_SANITIZE_STRING);
            $status = filter_input(INPUT_POST, "status", FILTER_SANITIZE_STRING);
            if(!empty($ticketid) && !empty($level) && !empty($status))
            {
                try
                {
                    $portCont->updatemyBusinessSupportTicketAdmin($ticketid, $level, $status);
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
  }
}
?>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>ADMIN | Online Clinic System</title>
    <meta name="description" content="">
    <meta name="keywords" content="">
    <link rel="stylesheet" href="../assets/css/style.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <style>
        #map { height: 50vh; }
        #marker-loader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.9);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            z-index: 9999;
        }
    </style>
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
            <?php include('../../route/account/superadmin/header/header.php'); ?>
            <?php include('../../route/account/superadmin/layout/layout.php'); ?>
            <div class="app-main">
                <?php include('../../route/account/superadmin/sidebar/sidebar.php'); ?>
                <div class="app-main__outer">
                    <div id="content" class="app-main__inner">
                        
                        <?php 
                        $view = $_GET['view'];
                            switch($view)
                            {
                                case "HOME":
                                    include('../../route/account/superadmin/dashboard.php');
                                    break;
                                case "BUSINESS":
                                    include('../../route/account/superadmin/business.php');
                                    break;
                                case "BUSINESSSPECIFIC":
                                    $account_id = $_GET['account_id'];
                                    $result = $portCont->myAccountBusinessCheck($account_id);
                                    include('../../route/account/superadmin/business_specific.php');
                                    break;
                                case "SERVICE":
                                    include('../../route/account/superadmin/service.php');
                                    break;
                                case "REPORTS":
                                    include('../../route/account/superadmin/reports.php');
                                    break;
                                case "INQUIRY":
                                    include('../../route/account/superadmin/inquiry.php');
                                    break;
                                case "BILLING":
                                    include('../../route/account/superadmin/billing.php');
                                    break;
                                case "INTEGRATION":
                                    include('../../route/account/superadmin/integration.php');
                                    break;
                                case "SUPPORT":
                                    include('../../route/account/superadmin/support.php');
                                    break;
                                case "SUPPORTSPECIFICRESPONSE":
                                    include('../../route/account/admin/supportspecific.php');
                                    break;
                                default:
                                    include('../../route/account/superadmin/404.php');
                                    break;
                            } 
                        ?>
                    </div>
                    <?php include('../../route/account/superadmin/footer/footer.php'); ?>
                </div>
            </div>
        </div>
        <!-- Modal -->
        <?php include('../../assets/modal/generic_modal.php'); ?>
        <!-- Modal -->                    
        <script type="text/javascript"
            src="../../assets/script/main.js"></script>
     
            <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script> 

        <!-- DataTables CSS for Bootstrap 5 -->
        <link rel="stylesheet" type="text/css"
            href="https://cdn.datatables.net/1.12.1/css/dataTables.bootstrap5.min.css">

        <!-- DataTables JavaScript for Bootstrap 5 -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.12.1/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.12.1/js/dataTables.bootstrap5.min.js"></script>
        <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>                    
        <?php  $view = isset($_GET['view']) ? $_GET['view'] : 'default'; ?>

        <script>
            document.addEventListener("DOMContentLoaded", function() {
                const view = "<?php echo $view; ?>";
                switch (view) {
                    case 'HOME':
                        const map = L.map('map').setView([12.8797, 121.7740], 5); // Philippines center

                        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                        maxZoom: 19
                        }).addTo(map);

                        async function loadMarkers() {
                        try {
                            const response = await fetch('../../api/locationsApi.php'); // Your PHP API
                            const data = await response.json();

                            const promises = data.map(async clinic => {
                            const fullAddress = `${clinic.barangay}, ${clinic.city}, Philippines`;
                            const url = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(fullAddress)}`;

                            const res = await fetch(url);
                            const locations = await res.json();

                            if (locations.length > 0) {
                                const lat = locations[0].lat;
                                const lon = locations[0].lon;
                                L.marker([lat, lon]).addTo(map)
                                .bindPopup(`
                                    <strong>Clinic ID:</strong> ${clinic.account_id}<br>
                                    <strong>Clinic:</strong> ${clinic.business_name}<br>
                                    <strong>Barangay:</strong> ${clinic.barangay}<br>
                                    <strong>City:</strong> ${clinic.city}
                                `);
                            } else {
                                console.warn(`No location found for: ${fullAddress}`);
                            }

                            // Respect Nominatim rate limit
                            await new Promise(r => setTimeout(r, 1000));
                            });

                            await Promise.all(promises);
                        } catch (err) {
                            console.error('❗ Failed to load clinic locations:', err);
                        } finally {
                            const loader = document.getElementById('marker-loader');
                            if (loader) loader.style.display = 'none';
                        }
                        }

                        loadMarkers();

                    google.charts.load("current", { packages: ["corechart"] });
                    google.charts.setOnLoadCallback(() => {
                    drawPieChart1Overall();
                    drawBarChartOverall();
                    drawPieChart2Overall();
                    drawBarChart2Overall();
                    });

                    // === First Pie Chart ===
                    function drawPieChart1Overall() {
                    fetch(`../../api/adminoverallpieChartsApi.php`)
                        .then((response) => response.json())
                        .then((result) => {
                        const dataArray = [["Method", "Count"]];
                        result.forEach((item) => {
                            dataArray.push([item.method, item.count]);
                        });

                        const data = google.visualization.arrayToDataTable(dataArray);
                        const options = {
                            title: "Profit Count Per Method",
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
                    function drawBarChartOverall() {
                    fetch(`../../api/adminoverallbarChartsApi.php`)
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
                            title: "Ticket",
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
                    fetch(`../../api/adminoverallbarChartsApiSecond.php`)
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
                    fetch(`../../api/adminoverallchartsApi.php`)
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
                    case 'BUSINESS':
                        loadScript('../../assets/js/dt.js');
                        break;
                    case 'BUSINESSSPECIFIC':
                        loadScript('../../assets/js/dt.js');
                        break;
                    case 'SERVICE':
                        loadScript('../../assets/js/dt.js');
                        break;
                    case 'INQUIRY':
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

        <!-- Include Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Include Flatpickr JS -->
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script> 

        <!-- generate datatable on our table -->

    </body>

    </html>

</body>

</html>