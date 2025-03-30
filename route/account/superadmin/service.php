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
            <div class="card-header">Service</div>
            <div class="table-responsive">
            <div class="col-md-12 mt-2">
                    <a href='#addService' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-universal-access'></i></span> Create Service</a>
                    <hr/>
                    <table id="serviceTable" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                             <th>AID</th>
                             <th>Account</th>
                             <th>Description</th>
                             <th>Amount</th>
                             <th>Created</th>
                             <th>Action</th>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myAccountBussinessAccountService();
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    echo 
                                    "<tr>
                                        <td>".$accounts['account_type']."</td>   
                                        <td>".$accounts['account']."</td>
                                        <td>".$accounts['description']."</td>
                                        <td>".$accounts['amount']."</td>
                                        <td>".$accounts['date_created']."</td>
                                        <td>
                                           <a href='#editServiceCreation_".$accounts['account_type']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-pencil'></i></span></a>
                                           <a href='#deleteServiceCreation_".$accounts['account_type']."' class='btn btn-danger btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-trash'></i></span></a>
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

