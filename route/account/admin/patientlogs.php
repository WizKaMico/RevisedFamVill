<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">ACTIVITY LOGS</div>
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
                            $client_id = $_GET['client_id'];
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
</div>