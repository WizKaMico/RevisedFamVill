<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Accounts</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                    <a href='#addRoles' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-universal-access'></i></span> Create Roles</a>
                    <a href='#addAccount' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-user-plus'></i></span> Create Account</a>
                    <hr/>
                    <table id="usersTable" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>ID</th>
                            <th>Fullname</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Role</th>
                            <th>Status</th>
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
                                        <td>".$accounts['status']."</td>
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