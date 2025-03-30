<?php if(!empty($notice[0]['announcement_title'])){ ?>
<div class="app-page-title">
    <div class="page-title-wrapper">
        <div class="col-md-12 col-xl-12">
            <div class="card widget-content bg-grow-early">
                <div class="widget-content-wrapper text-white">
                    <div class="widget-content-left">
                        <div class="widget-heading"><b><?php echo $notice[0]['announcement_title']; ?> : <?php echo $notice[0]['announcement_content']; ?></b></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<?php  } ?>


<div class="row mb-1">
    <div class="col-md-12">
        <div class="main-card mb-2 card">
            <div class="card-header">Welcome! <?php echo $account[0]['fullname']; ?></div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Upcoming Appointments</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                    <table id="upcomingTable"
                        class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>ID</th>
                            <th>PID</th>
                            <th>PATIENT</th>
                            <th>AGE</th>
                            <th>GENDER</th>
                            <th>PURPOSE</th>
                            <th>DESCRIPTION</th>
                            <th>DOCTOR</th>
                            <th>FEE</th>
                            <th>DIAGNOSIS</th>
                            <th>APPOINTMENT</th>
                            <th>STATUS</th>
                            <th>ACTION</th>
                        </thead>
                        <tbody>
                            <?php
                            $uid = $account[0]['client_id'];
                            date_default_timezone_set('Asia/Manila');
                            $dateToday = date('Y-m-d');
                            $accounts = $portCont->getAllUpcomingAppointment($uid,$dateToday);
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                        $code = rand(6666,9999);
                                        echo 
                                        "<tr>
                                            <td>".$accounts['aid']."</td>
                                            <td>".$accounts['pid']."</td>
                                            <td>".$accounts['fullname']."</td>
                                            <td>".$accounts['age']."</td>
                                            <td>".$accounts['gender']."</td>
                                            <td>".$accounts['service']."</td>
                                            <td>".$accounts['purpose_description']."</td>

                                            <td>".$accounts['doctor']."</td>
                                            <td>₱ ".$accounts['amount']."</td>
                                            <td>".$accounts['diagnosis']."</td>

                                            <td>".$accounts['schedule_date']."</td>
                                            <td>".$accounts['status']."</td>
                                            <td>";
                                            if(!empty($accounts['amount']))
                                            {
                                              if($accounts['status'] == "PAYED PENDING" || $accounts['status'] == "CONFIRMED")
                                              {
                                                include('../../assets/payment/GrabpayPatient.php');  
                                                include('../../assets/payment/GpayPatient.php'); 
                                                echo "
                                                    <a href='#payBILLINGAppointmentChargePatient_".$accounts['aid']."' class='btn btn-primary btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-money'></i></span></a>
                                                    <a href='#editAppointment_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-calendar'></i></span></a>
                                                    <a href='#informationAppointment_".$accounts['aid']."' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-user'></i></span></a>
                                                    <a href='#cancelBookingPatientAppointment_".$accounts['aid']."' class='btn btn-danger btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-close'></i></span></a>";
                                              }
                                              else
                                              {
                                                echo "
                                                <a href='#editAppointment_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-calendar'></i></span></a>
                                                <a href='#informationAppointment_".$accounts['aid']."' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-user'></i></span></a>
                                                <a href='#cancelBookingPatientAppointment_".$accounts['aid']."' class='btn btn-danger btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-close'></i></span></a>";
                                              }
                                            }
                                            else
                                            {
                                                echo "
                                                <a href='#editAppointment_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-calendar'></i></span></a>
                                                <a href='#informationAppointment_".$accounts['aid']."' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-user'></i></span></a>
                                                <a href='#cancelBookingPatientAppointment_".$accounts['aid']."' class='btn btn-danger btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-close'></i></span></a>";
                                            }
                                            echo "</td>
                                        </tr>";
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
</div>



<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Follow Up Appointments</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                <table id="activitySchedulingFollowup" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>Fid</th>
                            <th>Patient</th>
                            <th>Age</th>
                            <th>Gender</th>
                            <th>Followup</th>
                            <th>Status</th>
                            <th>Diagnosis</th>
                            <th>Doctor</th>
                            <th>Fee</th>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myPatientAppointmentFollowupDashboard($client_id);
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    echo 
                                    "<tr>
                                        <td>".$accounts['fid']."</td>   
                                        <td>".$accounts['fullname']."</td>
                                        <td>".$accounts['age']."</td>
                                        <td>".$accounts['gender']."</td>
                                        <td>".$accounts['followupdate']."</td>
                                        <td>".$accounts['status']."</td>
                                        <td>".$accounts['diagnosis']."</td>
                                        <td>".$accounts['doctor']."</td>
                                        <td>₱ ".$accounts['amount']."</td>
                                     </tr>";
                                }
                            }
                            ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    const dateInput = document.getElementById('schedule_date');
    const selectedDate = dateInput.value;

    // Set min date = today
    const today = new Date().toISOString().split('T')[0];
    dateInput.setAttribute('min', today);

    // Disable selected date on click
    dateInput.addEventListener('input', function(e) {
      const pickedDate = e.target.value;
      
      // Check if weekend
      const day = new Date(pickedDate).getDay();
      if (day === 6 || day === 0) { // Saturday or Sunday
        alert('Weekend dates are not allowed!');
        e.target.value = '';
        return;
      }

      // Check if same as previous selected date
      if (pickedDate === selectedDate) {
        alert('You cannot select the same date again.');
        e.target.value = '';
        return;
      }
    });
  });
</script>