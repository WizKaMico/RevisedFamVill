<div class="row g-2">
    <div class="col-md-12">
        <div class="main-card mb-2 card">
            <div class="card-header">Welcome! <?php echo $account[0]['fullname']; ?></div>
        </div>
    </div>
</div>

<div class="row mt-1">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Business</div>
            <div class="col-md-12 mt-2">
              <div class="table-responsive">
                <br />
                    <table id="businessTable" class="align-middle mb-0 mt-2 table table-borderless table-striped table-hover">
                            <thead>
                                <th>AID</th>
                                <th>Business</th>
                                <th>Contact</th>
                                <th>Email</th>
                                <th>Status</th>
                                <th>Account</th>
                                <th>Registration Date</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php
                                $accounts = $portCont->myAccountBussiness();
                                if (!empty($accounts)) {
                                    foreach ($accounts as $key => $accounts) {
                                        echo 
                                        "<tr>
                                            <td>".$accounts['account_id']."</td>
                                            <td>".$accounts['business_name']."</td>   
                                            <td>".$accounts['phone']."</td>
                                            <td>".$accounts['email']."</td>
                                            <td>".$accounts['status']."</td>
                                            <td>".$accounts['account']."</td>
                                            <td>".$accounts['date_created']."</td>
                                            <td>
                                            <a href='#businessInteruption_".$accounts['account_id']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-power-off'></i></span></a>
                                            <a href='?view=BUSINESSSPECIFIC&account_id=".$accounts['account_id']."' class='btn btn-success btn-sm'> <i class='fa fa-info-circle'></i></span></a>
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

