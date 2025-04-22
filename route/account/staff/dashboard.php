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


<div class="row">
    <div class="col-md-8">
        <div class="main-card mb-3 card">
            <div class="card-header">Todays Appointment</div>
            <div class="table-responsive">
                <div class="col-md-12">
                <table id="activityScheduling" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>Patient</th>
                            <th>Birthdate</th>
                            <th>Age</th>
                            <th>Gender</th>
                            <th>Appointment</th>
                            <th>Status</th>
                            <th>Purpose</th>
                            <th>Guardian</th>
                            <?php if($account[0]['sid'] == NULL) { ?>
                            <th>Action</th>
                            <?php } ?>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myClinicSchedulesToday($account_id);
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    echo 
                                    "<tr>
                                        <td>".$accounts['patient']."</td>   
                                        <td>".$accounts['dob']."</td>";
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
                                        echo "<td>".$accounts['gender']."</td>
                                        <td>".$accounts['schedule_date']."</td>
                                        <td>".$accounts['status']."</td>
                                        <td>".$accounts['purpose']."</td>
                                        <td>".$accounts['guardian']."</td>";

                                        if($account[0]['sid'] == NULL) {
                                       echo "<td>
                                           <a href='#editAppointment_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-calendar'></i></span></a>
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
        <div class="main-card card">
            <div class="card-header">Calendar</div>
            <div class="table-responsive p-2">
            <div class="col-md-12 p-0">
                <iframe 
                src="../../api/calendar.php?account_id=<?php echo $account_id;?>" 
                style="width: 100%; height: 550px; border: none; overflow: hidden;"
                scrolling="no"
                ></iframe>
            </div>
            </div>
        </div>
   </div>
</div>



<div class="row mt-2">
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
                            $accounts = $portCont->myPatientAppointmentFollowupBussiness($account_id);
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    echo 
                                    "<tr>
                                        <td>".$accounts['fid']."</td>   
                                        <td>".$accounts['fullname']."</td>";
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
                                        echo "<td>".$accounts['gender']."</td>
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