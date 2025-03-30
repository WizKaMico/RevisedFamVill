
<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Ticket Support</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                    <a href='#addTicketForSupport' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-terminal'></i></span> Create Ticket</a>
                    <hr/>
                    <table id="accountBilling" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>Ticket #</th>
                            <th>Priority</th>
                            <th>Subject</th>
                            <th>Concern</th>
                            <th>Status</th>
                            <th>Date Created</th>
                            <th>Action</th>
                        </thead>
                        <tbody>
                            <?php
                                $accounts = $portCont->myBusinessSupportTicketView($account_id);
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
                                               <a href='#editTicket_".$accounts['ticketid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-pencil'></i></span> Edit</a>
                                               <a href='#deleteTicket_".$accounts['ticketid']."' class='btn btn-danger btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-trash'></i></span> Delete</a>
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
