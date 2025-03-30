<div class="row g-2">
    <div class="col-md-12">
        <div class="main-card mb-2 card">
            <div class="card-header">Welcome! <?php echo $account[0]['fullname']; ?></div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Ticket Support</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                    <table id="accountBilling" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>Ticket #</th>
                            <th>level</th>
                            <th>Subject</th>
                            <th>Concern</th>
                            <th>Status</th>
                            <th>Date Created</th>
                            <th>Action</th>
                        </thead>
                        <tbody>
                            <?php
                                $accounts = $portCont->myBusinessSupportTicketViewAll();
                                if (!empty($accounts)) {
                                    foreach ($accounts as $key => $accounts) {
                                        echo 
                                        "<tr>
                                            <td>".$accounts['ticketid']."</td>   
                                            <td>".$accounts['level']."</td>
                                            <td>".$accounts['subject']."</td>
                                            <td>".$accounts['concern']."</td>
                                            <td>".$accounts['status']."</td>
                                            <td>".$accounts['date_created']."</td>
                                            <td>
                                               <a href='#editTicketAdmin_".$accounts['ticketid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-pencil'></i></span> Edit</a>
                                               <a href='?view=SUPPORTSPECIFICRESPONSE&ticketid=".$accounts['ticketid']."' class='btn btn-warning btn-sm'> <i class='fa fa-book'></i></span> History</a>
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
