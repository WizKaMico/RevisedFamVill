<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Reports</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="main-card mb-3 card">
            <div class="card-header">PROFIT : ₱ <?php echo $profitOverall[0]['total']; ?></div>
            <div id="piechart1" style="width: 100%; height: 400px;"></div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="main-card mb-3 card">
            <div class="card-header">APPOINTMENT : <?php echo $appointmentOverall[0]['count']; ?></div>
            <div id="barchart" style="width: 100%; height: 400px;"></div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="main-card mb-3 card">
            <div class="card-header">ACCOUNTS : <?php echo $accounts_chart_overall[0]['count']; ?></div>
            <div id="piechart2" style="width: 100%; height: 400px;"></div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="main-card mb-3 card">
            <div class="card-header">INQUIRY : <?php echo $inquiryOverall[0]['count']; ?></div>
            <div id="barchart2" style="width: 100%; height: 400px;"></div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-8">
        <div class="main-card mb-3 card">
            <div class="card-header">All Schedules</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                <table id="activityScheduling" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>Patient</th>
                            <th>Birthdate</th>
                            <th>Age</th>
                            <th>Gender</th>
                            <th>Schedule</th>
                            <th>Status</th>
                            <th>Purpose</th>
                            <th>Guardian</th>
                            <th>Method</th>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myClinicSchedules($account_id);
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    echo 
                                    "<tr>
                                        <td>".$accounts['patient']."</td>   
                                        <td>".$accounts['dob']."</td>
                                        <td>".$accounts['age']."</td>
                                        <td>".$accounts['gender']."</td>
                                        <td>".$accounts['schedule_date']."</td>
                                        <td>".$accounts['status']."</td>
                                        <td>".$accounts['purpose']."</td>
                                        <td>".$accounts['guardian']."</td>
                                        <td>".$accounts['payment_method']."</td>
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
    <div class="col-md-4">
    <div class="main-card mb-3 card">
        <div class="card-header">Calendar</div>
        <div class="table-responsive p-2">
        <div class="col-md-12 mt-2 p-0">
            <iframe 
            src="../../api/calendar.php?account_id=<?php echo $account_id; ?>" 
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
                            $accounts = $portCont->myPatientAppointmentFollowupBussinessOverall($account_id);
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