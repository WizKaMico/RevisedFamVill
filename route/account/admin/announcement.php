<div class="row">
    <div class="col-md-12">
        <div class="main-card mb-3 card">
            <div class="card-header">Announcement</div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                <a href='#addAnnouncement' class='btn btn-warning btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-bullhorn'></i></span> Create Announcement</a>
                <hr/>
                   <table id="accountBilling" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>Announcement Id</th>
                            <th>Title</th>
                            <th>Content</th>
                            <th>Status</th>
                            <th>Date Created</th>
                            <th>Action</th>
                        </thead>
                        <tbody>
                        <?php
                        $accounts = $portCont->myAccountAnnouncementCompany($account_id);
                        if (!empty($accounts)) {
                            foreach ($accounts as $key => $accounts) {
                
                                echo "<tr>
                                        <td>".$accounts['announcement_id']."</td>   
                                        <td>".$accounts['announcement_title']."</td>
                                        <td>".$accounts['announcement_content']."</td>
                                        <td>".$accounts['status']."</td>
                                        <td>".$accounts['date_created']."</td>
                                        <td>
                                           <a href='#editAnnouncement_".$accounts['announcement_id']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-pencil'></i></span> Edit</a>
                                           <a href='#deleteAnnouncement_".$accounts['announcement_id']."' class='btn btn-danger btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-trash'></i></span> Delete</a>
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