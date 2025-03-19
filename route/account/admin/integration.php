<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Integration</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                    <a href='#addIntegration' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-plug'></i></span> Paymongo Payment Integration</a>
                    <hr/>
                    <table id="payIntegrationTable" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>ID</th>
                            <th>PK</th>
                            <th>SK</th>
                            <th>Status</th>
                            <th>Mode</th>
                            <th>Date Created</th>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myAccountPaymentBillingView($account_id);
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    echo 
                                    "<tr>
                                        <td>".$accounts['pid']."</td>   
                                        <td>".$accounts['public_key']."</td>
                                        <td>".$accounts['secret_key']."</td>
                                        <td>".$accounts['status']."</td>
                                        <td>".$accounts['mode']."</td>
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
</div>