<div class="row g-2">
    <div class="col-md-12">
        <div class="main-card mb-2 card">
            <div class="card-header">Welcome! <?php echo $account[0]['fullname']; ?></div>
        </div>
    </div>
</div>

<div class="row mt-1">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Inquiry</div>
            <div class="table-responsive">
            <div class="col-md-12 mt-2">
                    <table id="serviceTable" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                             <th>INQID</th>
                             <th>Fullname</th>
                             <th>Email</th>
                             <th>Subject</th>
                             <th>Message</th>
                             <th>Date Created</th>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myAccountClinicInquiry();
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    echo 
                                    "<tr>
                                        <td>".$accounts['inq_id']."</td>   
                                        <td>".$accounts['fullname']."</td>
                                        <td>".$accounts['email']."</td>
                                        <td>".$accounts['subject']."</td>
                                        <td>".$accounts['message']."</td>
                                        <td>".$accounts['date_created']."</td>
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

