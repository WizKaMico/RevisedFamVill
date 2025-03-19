<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">History Appointments</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                    <table id="upcomingTable"
                        class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>ID</th>
                            <th>PID</th>
                            <th>PATIENT NAME</th>
                            <th>PATIENT AGE</th>
                            <th>PURPOSE</th>
                            <th>DATE OF APPOINTMENT</th>
                            <th>STATUS</th>
                        </thead>
                        <tbody>
                            <?php
                            $uid = $account[0]['client_id'];
                            $appointment = $portCont->getAllUpcomingAppointmentHistoryForPatient($uid);
                            if (!empty($appointment)) {
                                foreach ($appointment as $key => $value) {
                                        echo 
                                        "<tr>
                                            <td>".$value['aid']."</td>
                                            <td>".$value['pid']."</td>
                                            <td>".$value['fullname']."</td>
                                            <td>".$value['age']."</td>
                                            <td>".$value['service']."</td>
                                            <td>".$value['schedule_date']."</td>
                                             <td>".$value['status']."</td>
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