<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Patient</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                <?php if($account[0]['sid'] == NULL) { ?>
                <a href='#addPatient' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-street-view'></i></span> Create Patient</a>
                <?php } ?>
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
                                        <td>".$accounts['status']."</td>";
                                        if($account[0]['sid'] == NULL) { 
                                            echo 
                                            "<td>
                                            <a href='?view=SPECIFICACCOUNTBOOK&client_id=".$accounts['client_id']."' class='btn btn-primary btn-sm'> <i class='fa fa-book'></i></span> Book</a>  
                                            </td>";
                                        }else{
                                            echo 
                                            "<td>
                                            <a href='?view=SPECIFICACCOUNTBOOK&client_id=".$accounts['client_id']."' class='btn btn-primary btn-sm'> <i class='fa fa-book'></i></span> View</a>  
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
</div>