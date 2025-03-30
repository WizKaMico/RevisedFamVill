<div class="row g-2">
    <div class="col-md-12">
        <div class="main-card mb-2 card">
            <div class="card-header">Welcome! <?php echo $account[0]['fullname']; ?></div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="main-card mb-3 card">
            <div class="card-header">PROFIT : ₱ <?php if(!empty($profit[0]['total'])) { echo $profit[0]['total']; } ?></div>
            <div id="piechart1" style="width: 100%; height: 400px;"></div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="main-card mb-3 card">
            <div class="card-header">TICKET : <?php if(!empty($ticket[0]['count'])) { echo $ticket[0]['count']; } ?></div>
            <div id="barchart" style="width: 100%; height: 400px;"></div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="main-card mb-3 card">
            <div class="card-header">ACCOUNTS : <?php if(!empty($subscription[0]['count'])) { echo $subscription[0]['count']; } ?></div>
            <div id="piechart2" style="width: 100%; height: 400px;"></div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="main-card mb-3 card">
            <div class="card-header">INQUIRY : <?php  if(!empty($inquiry[0]['count'])) { echo $inquiry[0]['count']; } ?></div>
            <div id="barchart2" style="width: 100%; height: 400px;"></div>
        </div>
    </div>
</div>

<div class="row mt-1">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Map</div>
            <div class="table-responsive">
                <div id="marker-loader">Loading clinic locations...</div>
                <div id="map"></div>
            </div>
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

