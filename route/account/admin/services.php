<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Services</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                    <a href='#createService' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-universal-access'></i></span> Create Service</a>
                    <hr/>
                    <table id="serviceTable" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                             <th>Service Id</th>
                             <th>Service Offer</th>
                             <th>Date Created</th>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->viewAccountService($account_id);
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    echo 
                                    "<tr>
                                        <td>".$accounts['bsid']."</td>   
                                        <td>".$accounts['service']."</td>
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