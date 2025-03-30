<?php 
$aid = $_GET['aid'];
$client_id = $_GET['client_id'];
$specificAccount = $portCont->myClinicSpecificAccountInfo($account_id,$client_id); 
?>
<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">APPOINTMENT HISTORY OF <?php echo strtoupper($specificAccount[0]['fullname']); ?></div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
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


