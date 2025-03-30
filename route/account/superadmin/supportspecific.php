<?php $ticketid = $_GET['ticketid']; ?>
<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Ticket Support Response</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                <a href='#addTicketResponseForSupport' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-terminal'></i></span> Create Ticket Response</a>
                    <hr/>
                    <table id="accountBilling" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>Ticket #</th>
                            <th>ResponseId</th>
                            <th>Response</th>
                        </thead>
                        <tbody>
                        <?php
                                $accounts = $portCont->viewTicketResponse($ticketid);
                                if (!empty($accounts)) {
                                    foreach ($accounts as $key => $accounts) {
                                        echo 
                                        "<tr>
                                            <td>".$accounts['ticket_id']."</td>   
                                            <td>".$accounts['response_id']."</td>
                                            <td>".$accounts['response']."</td>
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
