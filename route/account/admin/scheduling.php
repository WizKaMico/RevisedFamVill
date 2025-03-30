<div class="row">
    <div class="col-md-12">
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
                            <th>Appointment Schedule</th>
                            <th>Status</th>
                            <th>Purpose</th>
                            <th>Guardian</th>
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