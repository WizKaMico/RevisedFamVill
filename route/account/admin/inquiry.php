<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Inquiry</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                   <table id="accountBilling" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>Bid</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Subject</th>
                            <th>Message</th>
                            <th>Date Created</th>
                        </thead>
                        <tbody>
                        <?php
                        $accounts = $portCont->myAccountInquiryCompany($account_id);
                        if (!empty($accounts)) {
                            foreach ($accounts as $key => $accounts) {
                
                                echo "<tr>
                                        <td>".$accounts['bid']."</td>   
                                        <td>".$accounts['name']."</td>
                                        <td>".$accounts['email']."</td>
                                        <td>".$accounts['subject']."</td>
                                        <td>".$accounts['message']."</td>
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