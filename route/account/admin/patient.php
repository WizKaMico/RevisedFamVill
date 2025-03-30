<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Patient</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                <a href='#addPatient' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-street-view'></i></span> Create Patient</a>
                <hr/>
                <table id="activityPatient" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>Client Id</th>
                            <th>Fullname</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Status</th>
                            <th>Action</th>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myPatientAccounts($account_id);
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    echo 
                                    "<tr>
                                        <td>".$accounts['client_id']."</td>   
                                        <td>".$accounts['fullname']."</td>
                                        <td>".$accounts['username']."</td>
                                        <td>".$accounts['email']."</td>
                                        <td>".$accounts['phone']."</td>
                                        <td>".$accounts['status']."</td>
                                        <td>
                                           <a href='#editPatient_".$accounts['client_id']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-pencil'></i></span> Edit</a>
                                           <a href='#ActivePatient_".$accounts['client_id']."' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-toggle-off'></i></span> Activate/Deact</a>
                                           <a href='#deletePatient_".$accounts['client_id']."' class='btn btn-danger btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-trash'></i></span> Delete</a>
                                           <a href='?view=SPECIFICACCOUNTBOOK&client_id=".$accounts['client_id']."' class='btn btn-primary btn-sm'> <i class='fa fa-book'></i></span> Book</a> 
                                           <a href='?view=ACTIVITYLOGS&client_id=".$accounts['client_id']."' class='btn btn-primary btn-sm'> <i class='fa fa-book'></i></span> Activity Logs</a>   
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