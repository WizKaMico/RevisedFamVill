<?php 
$aid = $_GET['aid'];
$client_id = $_GET['client_id'];
$specificAccount = $portCont->myClinicSpecificAccountInfo($account_id,$client_id); 
?>
<div class="row">
    <div class="col-md-8">
        <div class="main-card mb-3 card">
            <div class="card-header">APPOINTMENT HISTORY OF <?php echo strtoupper($specificAccount[0]['fullname']); ?></div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                <a href='#addDiagnosis' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-edit'></i></span> Diagnosis Feedback</a>
                <a href='#addFollowup' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-calendar-o'></i></span> Follow Up CheckUp</a>
                <hr/>    
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
                            <th>Diagnosis</th>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myClinicSpecificAccountBookingSpecific($aid,$account_id,$client_id);
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    echo 
                                    "<tr>
                                        <td>".$accounts['patient']."</td>   
                                        <td>".$accounts['age']."</td>
                                        <td>".$accounts['gender']."</td>
                                        <td>".$accounts['doctor']."</td>
                                        <td>₱ ".$accounts['amount']."</td>
                                        <td>".$accounts['schedule_date']."</td>
                                        <td>".$accounts['status']."</td>
                                        <td>".$accounts['purpose']."</td>
                                        <td>".$accounts['diagnosis']."</td>
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
    <div class="col-4">
        <div class="main-card mb-3 card">
            <div class="card-header">FEEDBACK</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                <table id="activityFeedback" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>Rate</th>
                            <th>Feedback</th>
                            <th>Date Created</th>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myClinicSpecificAccountBookingSpecificFeedback($aid);
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    echo 
                                    "<tr>
                                        <td>".$accounts['rate']."</td>   
                                        <td>".$accounts['feedback']."</td>
                                        <td>".$accounts['date_created']."</td>
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


<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">APPOINTMENT FOLLOW UP | <?php echo strtoupper($specificAccount[0]['fullname']); ?></div>
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
                            <th>Action</th>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myPatientAppointmentFollowup($aid);
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
                                        <td>
                                            <a href='#followupAppointmentReschedule_".$accounts['fid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-calendar'></i></span></a>
                                            <a href='#followupAppointmentDiagnosis_".$accounts['fid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-heartbeat'></i></span></a>
                                            <a href='#followupAppointmentStatus_".$accounts['fid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-edit'></i></span></a>
                                        </td>
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