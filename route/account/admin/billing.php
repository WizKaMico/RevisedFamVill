<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Billing</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                   <table id="accountBilling" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>Bill</th>
                            <th>Method</th>
                            <th>TransID</th>
                            <th>Email</th>
                            <th>Status</th>
                            <th>Date Pay</th>
                            <th>Next Pay</th>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myAccountPaymentBilling($account_id);
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    echo 
                                    "<tr>
                                        <td>".$accounts['subs_id']."</td>   
                                        <td>".$accounts['paymethod']."</td>
                                        <td>".$accounts['trans_id']."</td>
                                        <td>".$accounts['email']."</td>
                                        <td>".$accounts['status']."</td>
                                        <td>".$accounts['date_created']."</td>
                                        <td>".date('Y-m-d', strtotime($accounts['date_created'] . ' +30 days'))."</td>
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