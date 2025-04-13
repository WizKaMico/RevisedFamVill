<div class="row">
    <div class="col-md-9">
        <div class="main-card mb-3 card">
            <div class="card-header">Accounts</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                    <a href='#addRoles' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-universal-access'></i></span> Create Roles</a>
                    <a href='#addAccount' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-user-plus'></i></span> Create Account</a>
                    <a href='#addServiceRole' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-vcard'></i></span> Service Role</a>
                    <hr/>
                    <table id="usersTable" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>ID</th>
                            <th>Fullname</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Role</th>
                            <th>Rate</th>
                            <th>Status</th>
                            <th>Action</th>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myAccountUsers($account_id);
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    echo 
                                    "<tr>
                                        <td>".$accounts['user_id']."</td>   
                                        <td>".$accounts['fullname']."</td>
                                        <td>".$accounts['email']."</td>
                                        <td>".$accounts['phone']."</td>
                                        <td>".$accounts['role_name']."</td>
                                        <td>₱ ".$accounts['paygrade']."</td>
                                        <td>".$accounts['status']."</td>
                                        <td>
                                           <a href='#editAccounts_".$accounts['user_id']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-pencil'></i></span> Edit</a>
                                           <a href='#deactivateAccounts_".$accounts['user_id']."' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-toggle-off'></i></span> Deactivate</a>
                                           <a href='#paygradeAccounts_".$accounts['user_id']."' class='btn btn-primary btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-money'></i></span> Rate</a>
                                           <a href='#deleteAccounts_".$accounts['user_id']."' class='btn btn-danger btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-trash'></i></span> Delete</a>
                                          <a href='?view=STAFFLOGS&user_id=".$accounts['user_id']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-pencil'></i></span> Logs</a>  
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
    <div class="col-md-3">
        <div class="main-card mb-3 card">
            <div class="card-header">Roles In Service</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                    <hr/>
                    <table id="sRoleTable" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>Id</th>
                            <th>Role</th>
                            <!-- <th>Action</th> -->
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myAccountUsersService($account_id);
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    echo 
                                    "<tr>
                                        <td>".$accounts['sid']."</td>   
                                        <td>".$accounts['role_name']."</td>
                                        
                                    </tr>";
                                    // <td>
                                        //  <a href='#deleteServiceRoleAccounts_".$accounts['sid']."' class='btn btn-danger btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-trash'></i></span> Delete</a>
                                        // </td>
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
