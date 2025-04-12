<div class="row g-2">
    <div class="col-md-12">
        <div class="main-card mb-2 card">
            <div class="card-header">Welcome! <?php echo $account[0]['email']; ?></div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="main-card mb-3 card">
            <div class="card-header">PROFIT : ₱ <?php echo $profit[0]['total']; ?></div>
            <div id="piechart1" style="width: 100%; height: 400px;"></div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="main-card mb-3 card">
            <div class="card-header">APPOINTMENT : <?php echo $appointment[0]['count']; ?></div>
            <div id="barchart" style="width: 100%; height: 400px;"></div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="main-card mb-3 card">
            <div class="card-header">ACCOUNTS : <?php echo $inquiry[0]['count']; ?></div>
            <div id="piechart2" style="width: 100%; height: 400px;"></div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="main-card mb-3 card">
            <div class="card-header">INQUIRY : <?php echo $accounts_chart[0]['count']; ?></div>
            <div id="barchart2" style="width: 100%; height: 400px;"></div>
        </div>
    </div>
</div>

<div class="row mt-1">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Todays Appointment</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                <table id="activityScheduling" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>Patient</th>
                            <th>Birthdate</th>
                            <th>Age</th>
                            <th>Gender</th>
                            <th>Appointment Schedule</th>
                            <th>Status</th>
                            <th>Purpose</th>
                            <th>Guardian</th>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myClinicSchedulesToday($account_id);
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