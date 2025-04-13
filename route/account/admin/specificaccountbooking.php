<?php 
$client_id = $_GET['client_id'];
$specificAccount = $portCont->myClinicSpecificAccountInfo($account_id,$client_id); 
?>
<div class="row">
    <div class="col-md-8">
        <div class="main-card mb-3 card">
            <div class="card-header">APPOINTMENT HISTORY OF <?php echo strtoupper($specificAccount[0]['fullname']); ?></div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                <table id="activityScheduling" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>Patient</th>
                            <th>Age</th>
                            <th>Gender</th>
                            <th>Doctor</th>
                            <th>Rate</th>
                            <th>Schedule</th>
                            <th>Status</th>
                            <th>Purpose</th>
                            <th>Action</th>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myClinicSpecificAccountBooking($account_id,$client_id);
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    $code = rand(6666, 9999);
                                    echo 
                                    "<tr>
                                        <td>".$accounts['patient']."</td>";

                                        if ($accounts['age'] > 0) {
                                            echo "<td>" . $accounts['age'] . " y/o</td>";
                                        } else {
                                            $dob = new DateTime($accounts['dob']);
                                            $today = new DateTime();
                                            $interval = $dob->diff($today);
                                        
                                            if ($interval->m == 0 && $interval->y == 0) {
                                                echo "<td>" . $interval->d . " day(s) old</td>";
                                            } elseif ($interval->y == 0) {
                                                echo "<td>" . $interval->m . " month(s) old</td>";
                                            } else {
                                                echo "<td>0</td>"; // fallback
                                            }
                                        }
                                        
                                    echo 
                                       "<td>".$accounts['gender']."</td>
                                        <td>".$accounts['doctor']."</td>
                                        <td>₱ ".$accounts['amount']."</td>
                                        <td>".$accounts['schedule_date']."</td>
                                        <td>".$accounts['status']."</td>
                                        <td>".$accounts['purpose']."</td>";
                                    if($accounts['status'] != 'CANCELLED') {
                                        if(empty($accounts['amount'])){
                                        echo 
                                        "<td>
                                            <a href='#assignDoctorPatient_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-user-plus'></i></span></a>
                                            <a href='#updateStatus_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-flag'></i></span></a>
                                            <a href='?view=SPECIFICACCOUNTBOOKVIEW&aid=".$accounts['aid']."&client_id=".$client_id."' class='btn btn-success btn-sm'> <i class='fa fa-folder-open'></i></span></a>
                                        </td>";
                                        }else{
                                            if($accounts['status'] == "CONFIRMED" || $accounts['status'] == "PAYED PENDING")
                                            {
                                                include('../../assets/payment/GrabpayOwner.php');  
                                                include('../../assets/payment/GpayOwner.php'); 
                                                echo
                                                "<td>
                                                    <a href='#payBILLINGAppointmentCharge_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-money'></i></span></a>
                                                    <a href='#updateStatus_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-flag'></i></span></a>
                                                    <a href='?view=SPECIFICACCOUNTBOOKVIEW&aid=".$accounts['aid']."&client_id=".$client_id."' class='btn btn-success btn-sm'> <i class='fa fa-folder-open'></i></span></a>
                                                </td>";
                                            }else{
                                                echo
                                                "<td>
                                                    <a href='#updateStatus_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-flag'></i></span></a>
                                                    <a href='?view=SPECIFICACCOUNTBOOKVIEW&aid=".$accounts['aid']."&client_id=".$client_id."' class='btn btn-success btn-sm'> <i class='fa fa-folder-open'></i></span></a>
                                                </td>";
                                            }
                                        }
                                    }else{
                                        echo
                                        "<td>
                                            <a href='#updateStatus_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-flag'></i></span></a>
                                        </td>";
                                    }

                                    echo "</tr>";
                                    include('../../assets/modal/generic_update_modal.php');   
                                }
                            }
                            ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="main-card mb-3 card">
            <div class="card-header">BOOK APPOINTMENT</div>
              <div class="table-responsive">
                <div class="col-md-12 mt-2">
                    <form action="?view=SPECIFICACCOUNTBOOK&action=BOOK" method="POST">
                         <div class="mb-3 mt-3">
                             <label for="fullname" class="form-label">Patient Name:</label>
                             <input type="text" class="form-control" id="fullname" placeholder="Enter Patient Name"
                                 name="fullname">
                                 <input type="hidden" class="form-control" id="contact"
                                 value="<?php echo $_GET['client_id']; ?>" name="client_id" readonly="">
                         </div>
                         <div class="mb-3 mt-3">
                             <label for="fullname" class="form-label">Contact:</label>
                             <input type="number" class="form-control" id="contact"
                                 value="<?php echo $specificAccount[0]['phone']; ?>" name="contact" readonly="">
                         </div>
                         <div class="mb-3">
                             <label for="dob" class="form-label">Date of Birth:</label>
                             <?php 
                             date_default_timezone_set('Asia/Manila'); 
                             $date = date('Y-m-d');
                             ?>

                             <input type="date" class="form-control" id="dob" min="2008-01-01" max="<?php echo $date; ?>" placeholder="Enter Date of Birth"
                                 name="dob">
                         </div>
                         <div class="mb-3">
                             <label for="gender" class="form-label">Gender:</label>
                             <select name="gender" class="form-control" required="">
                                 <option value="">CHOOSE GENDER</option>
                                 <option value="MALE">MALE</option>
                                 <option value="FEMALE">FEMALE</option>
                             </select>
                         </div>
                         <div class="mb-3">
                             <label for="purpose" class="form-label">Purpose of Visit:</label>
                             <select name="purpose" class="form-control" required="">
                                 <option value="">CHOOSE PURPOSE</option>
                                 <?php 
                                        $accounts = $portCont->viewAccountService($account_id);
                                        if (!empty($accounts)) {
                                            foreach ($accounts as $key => $accounts) {
                                 ?>
                                    <option value="<?php echo $accounts['bsid']; ?> "><?php echo $accounts['service']; ?></option>
                                    <?php } } ?> 
                             </select>
                         </div>
                         <div class="mb-3">
                             <label for="description" class="form-label">Purpose of Description:</label>
                             <textarea cols="5" rows="10" class="form-control" name="purpose_description"></textarea>
                         </div>
                         <div class="mb-3">
                            <label for="optionSelect" class="form-label">Choose Date Option:</label>
                            <select id="optionSelect" name="date_option" class="form-select">
                                <option value="today">Today</option>
                                <option value="other">Other Day</option>
                            </select>
                        </div>

                        <div id="dateToday" class="mb-3">
                            <label for="doaToday" class="form-label">Date of Appointment:</label>
                            <input type="date" name="doa1" class="form-control" id="doaToday" 
                                value="<?php echo date('Y-m-d'); ?>" readonly>

                            <hr />
                            <label for="user_id" class="form-label">Assign Doctor:</label>                    
                            <select class="form-control" name="user_id" required="">
                                    <?php 
                                        $staff = $portCont->clinic_business_account_service_employee($account[0]['account_id']);
                                        if (!empty($staff)) {
                                            foreach ($staff as $key => $staff) {
                                    ?>
                                    <option value="<?php echo $staff['user_id']; ?> "><?php echo $staff['fullname']; ?></option>
                                    <?php } } ?>
                            </select>
                        </div>

                        <div id="dateOther" class="mb-3" style="display: none;">
                            <label for="doaOther" class="form-label">Date of Appointment:</label>
                            <input type="text" name="doa2" class="form-control" id="doa" readonly
                            placeholder="Enter Date of Appointment">
                        </div>


                         <input type="hidden" name="fromIns" class="form-control" id="fromIns" value="WEB">
                         <div class="mb-3">
                             <button type="submit" name="submit" class="btn btn-primary w-100">Submit</button>
                         </div>
                     </form>
                </div>
             </div>
        </div>
    </div>
</div>


<script>
    const optionSelect = document.getElementById('optionSelect');
    const dateToday = document.getElementById('dateToday');
    const dateOther = document.getElementById('dateOther');

    optionSelect.addEventListener('change', function () {
        if (this.value === 'today') {
            dateToday.style.display = 'block';
            dateOther.style.display = 'none';
        } else {
            dateToday.style.display = 'none';
            dateOther.style.display = 'block';
        }
    });
</script>
