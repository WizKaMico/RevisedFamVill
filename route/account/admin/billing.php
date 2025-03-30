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
                            <th>Days Remaining</th>
                            <th>Account</th>
                            <th>Amount</th>
                            <th>Action</th>
                        </thead>
                        <tbody>
                        <?php
                        $accounts = $portCont->myAccountPaymentBilling($account_id);
                        if (!empty($accounts)) {
                            $lastIndex = count($accounts) - 1; // Get the index of the last item

                            foreach ($accounts as $key => $accounts) {
                                $dateCreated = $accounts['date_created']; 
                                $expiryDate = date('Y-m-d', strtotime($dateCreated . ' +30 days')); 
                                $remainingDays = ceil((strtotime($expiryDate) - time()) / 86400); 
                                $remainingDays = max(0, $remainingDays);
                                $nextBillingDate = date('Y-m-d', strtotime("+".(30 + $remainingDays)." days"));
                                include('../../assets/payment/GrabpayOwner.php');  
                                include('../../assets/payment/GpayOwner.php');  
                                $code = rand(6666, 9999);

                                echo "<tr>
                                        <td>".$accounts['subs_id']."</td>   
                                        <td>".$accounts['paymethod']."</td>
                                        <td>".$accounts['trans_id']."</td>
                                        <td>".$accounts['email']."</td>
                                        <td>".$accounts['status']."</td>
                                        <td>".$accounts['date_created']."</td>
                                        <td>".$nextBillingDate."</td>
                                        <td>".$remainingDays." days left</td>
                                        <td>".$accounts['account']."</td>
                                        <td>₱ ".$accounts['amount']."</td>
                                        <td>";

                                // Show "EXTEND PAY" button only for the latest entry
                                if ($key === $lastIndex) {
                                    echo "<a href='#payBILLING_".$accounts['subs_id']."' data-toggle='modal' data-backdrop='false' class='btn btn-success btn-sm'> 
                                            <i class='fa fa-money'></i> EXTEND PAY
                                        </a>";
                                }

                                echo "</td></tr>";

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