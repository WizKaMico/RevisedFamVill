<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Patient</div>
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
                            <th>ACTION</th>
                        </thead>
                        <tbody>
                            <?php
                            $account_id = $account[0]['account_id'];
                            date_default_timezone_set('Asia/Manila');
                            $dateToday = date('Y-m-d');
                            $appointment = $portCont->getAllUpcomingAppointmentBusinessAll($account_id);
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
                                            <td>
                                                <a href='#' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'>View Patient</a>
                                            </td>
                                        </tr>";
                                        include('../../assets/modal/generic_modal.php');
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
