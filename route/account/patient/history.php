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
                            <th>PATIENT</th>
                            <th>AGE</th>
                            <th>GENDER</th>
                            <th>PURPOSE</th>
                            <th>DESCRIPTION</th>
                            <th>DOCTOR</th>
                            <th>FEE</th>
                            <th>DIAGNOSIS</th>
                            <th>APPOINTMENT</th>
                            <th>ACTION</th>
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
                                            <td>".$value['gender']."</td>
                                            <td>".$value['service']."</td>
                                            <td>".$value['purpose_description']."</td>

                                            <td>".$value['doctor']."</td>
                                            <td>₱ ".$value['paygrade']."</td>
                                            <td>".$value['diagnosis']."</td>

                                            <td>".$value['schedule_date']."</td>
                                            <td>
                                              <a href='?view=SPECIFICACCOUNTBOOKVIEW&aid=".$value['aid']."&client_id=".$uid."' class='btn btn-success btn-sm'> <i class='fa fa-folder-open'></i></span></a>
                                               <a href='#addUpdateComment_".$value['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-comments-o'></i></span></a>
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