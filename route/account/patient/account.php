<div class="row mb-1">
    <div class="col-md-12">
        <div class="main-card mb-2 card">
            <div class="card-header">Welcome! <?php echo $account[0]['fullname']; ?></div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-8">
        <div class="main-card mb-3 card">
            <div class="card-header">Account History</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                    <table id="accountBilling" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>Activity</th>
                            <th>Page</th>
                            <th>Date</th>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myAccountPatientActivity($client_id);
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    echo 
                                    "<tr>
                                        <td>".$accounts['account_activity']."</td>   
                                        <td>".$accounts['page']."</td>
                                        <td>".$accounts['date_created']."</td>
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
            <div class="card-header">Account</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                <center>
                         <h5><span class="fa fa-folder-open-o mt-2"></span> Account Information</h5>
                        </center>
                         <hr />
                         <form action="#" method="POST">
                             <div class="mb-3 mt-3">
                                 <label for="email" class="form-label">Fullname:</label>
                                 <input type="email" class="form-control" value="<?php echo $account[0]['fullname']; ?>" required="" readonly="">
                             </div>
                             <div class="mb-3 mt-3">
                                 <label for="email" class="form-label">Username:</label>
                                 <input type="email" class="form-control" value="<?php echo $account[0]['username']; ?>" required="" readonly="">
                             </div>
                             <div class="mb-3 mt-3">
                                 <label for="email" class="form-label">Email:</label>
                                 <input type="email" class="form-control" value="<?php echo $account[0]['email']; ?>" required="" readonly="">
                             </div>
                             <div class="mb-3 mt-3">
                                 <label for="contact" class="form-label">Contact:</label>
                                 <input type="number" class="form-control" value="<?php echo $account[0]['phone']; ?>" required="" readonly="">
                             </div>
                         </form>
                </div>
            </div>
        </div>
    </div>
</div>
