<!-- Modal -->
<div class="modal fade mt-5" id="datePickerModal" tabindex="-1"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <!-- Flatpickr calendar will render here -->
                 <center>
                   <div id="flatpickr-container" style="width:100%;"></div>
                </center>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
            </div>

        </div>
    </div>
</div>
<!-- Modal -->

<div class="modal fade mt-5" id="addAnnouncement" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                CREATE ANNOUNCEMENT
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=ANNOUNCEMENT&action=CREATEANNOUNCEMENT">
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Title :</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="announcement_title" class="form-control" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Content :</label>
                            </div>
                            <div class="col-sm-12">
                                <textarea col="5" name="announcement_content" rows="5" class="form-control" required=""></textarea>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Status:</label>
                            </div>
                            <div class="col-sm-12">
                                <select class="form-control" name="status" required="">
                                    <option value="ACTIVE">ACTIVE</option>
                                    <option value="IN-ACTIVE">IN-ACTIVE</option>
                                </select>
                            </div>
                        </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Create</a>
                    </form>
            </div>

        </div>
    </div>
</div>

<div class="modal fade mt-5" id="addRoles" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=ACCOUNTS&action=CREATEROLE">
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Role Name:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="role_name" class="form-control" required="">
                            </div>
                        </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Create</a>
                    </form>
            </div>

        </div>
    </div>
</div>

<div class="modal fade mt-5" id="addAccount" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=ACCOUNTS&action=CREATEACCOUNT">
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Fullname:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="fullname" class="form-control" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Email:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="email" class="form-control" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Phone:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="phone" class="form-control" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Password:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="password" class="form-control" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Role:</label>
                            </div>
                            <div class="col-sm-12">
                                <select class="form-control" name="role" required="">
                                    <?php 
                                        $availRoles = $portCont->clinic_business_account_roles($account[0]['account_id']);
                                        if (!empty($availRoles)) {
                                            foreach ($availRoles as $key => $availRoles) {
                                    ?>
                                    <option value="<?php echo $availRoles['role_id']; ?> "><?php echo $availRoles['role_name']; ?></option>
                                    <?php } } ?>
                                </select>
                            </div>
                        </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Create</a>
                    </form>
            </div>

        </div>
    </div>
</div>

<div class="modal fade mt-5" id="addServiceRole" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=ACCOUNTS&action=CREATESERVICEROLE">
                       <p><b> NOTE: Service role is important since this define the account role to accomodate services </b></p>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Role:</label>
                            </div>
                            <div class="col-sm-12">
                                <select class="form-control" name="role" required="">
                                    <?php 
                                        $availRoles = $portCont->clinic_business_account_roles($account[0]['account_id']);
                                        if (!empty($availRoles)) {
                                            foreach ($availRoles as $key => $availRoles) {
                                    ?>
                                    <option value="<?php echo $availRoles['role_id']; ?> "><?php echo $availRoles['role_name']; ?></option>
                                    <?php } } ?>
                                </select>
                            </div>
                        </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Create</a>
                    </form>
            </div>

        </div>
    </div>
</div>



<div class="modal fade mt-5" id="addPatient" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>CREATE PATIENT</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=PATIENT&action=CREATEPATIENT">
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Fullname:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="fullname" class="form-control" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Username:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="username" class="form-control" required="">
                            </div>
                        </div>   
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Email:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="email" class="form-control" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Phone:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="phone" class="form-control" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Password:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="password" class="form-control" required="">
                            </div>
                        </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Create</a>
                    </form>
            </div>

        </div>
    </div>
</div>



<div class="modal fade mt-5" id="addIntegration" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=INTEGRATION&action=INTEGRATION">
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Public Key:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="public_key" class="form-control" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Secret Key:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="secret_key" class="form-control" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Status:</label>
                            </div>
                            <div class="col-sm-12">
                                <select class="form-control" name="status" required="">
                                    <option value="Active">Active</option>  
                                    <option value="In-Active">In-Active</option>        
                                </select>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Mode:</label>
                            </div>
                            <div class="col-sm-12">
                                <select class="form-control" name="mode" required="">
                                    <option value="Testing">Testing</option>  
                                    <option value="Live">Live</option>        
                                </select>
                            </div>
                        </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Create</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<div class="modal fade mt-5" id="createService" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=SERVICE&action=SERVICE">
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Service:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="service" class="form-control" required="">
                            </div>
                        </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Create</a>
                    </form>
            </div>

        </div>
    </div>
</div>

<div class="modal fade mt-5" id="addProduct" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=PRODUCT&action=PRODUCT" enctype="multipart/form-data">
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Product Name:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="name" class="form-control" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Product Code:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="code" class="form-control" value="<?php echo rand(6666,9999); ?>" required="" readonly="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Product Image:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="file" name="image" class="form-control" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Product Price:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="number" name="price" class="form-control" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Product Quantity:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="number" name="quantity" class="form-control" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Status:</label>
                            </div>
                            <div class="col-sm-12">
                                <select class="form-control" name="status" required="">
                                    <option value="Available">Available</option>  
                                    <option value="Un-Available">Un-Available</option>        
                                </select>
                            </div>
                        </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Create</a>
                    </form>
            </div>

        </div>
    </div>
</div>



<div class="modal fade mt-5" id="addDiagnosis" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>DIAGNOSIS | <?php echo strtoupper($specificAccount[0]['fullname']); ?></h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=SPECIFICACCOUNTBOOKVIEW&action=ADDINGOFDIAGNOSIS">
                         <input type="hidden" name="aid" class="form-control" value="<?php echo $_GET['aid']; ?>" required="" readonly="">
                         <input type="hidden" name="client_id" class="form-control" value="<?php echo $_GET['client_id']; ?>" required="" readonly="">
                         
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">DIAGNOSIS:</label>
                            </div>
                            <div class="col-sm-12">
                               <textarea col="5" name="diagnosis" rows="5" class="form-control" required=""></textarea>
                            </div>
                        </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Create</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<div class="modal fade mt-5" id="addFollowup" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>FOLLOW UP | <?php echo strtoupper($specificAccount[0]['fullname']); ?></h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=SPECIFICACCOUNTBOOKVIEW&action=ADDFOLLOWUP">
                    <input type="hidden" name="aid" class="form-control" value="<?php echo $_GET['aid']; ?>" required="" readonly="">
                    <input type="hidden" name="client_id" class="form-control" value="<?php echo $_GET['client_id']; ?>" required="" readonly="">
                    <input type="hidden" name="user_id" class="form-control" value="<?php echo $user_id; ?>" required="" readonly="">
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Follow up appointment:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="date" name="schedule_date" id="schedule_date" class="form-control"/>
                            </div>
                        </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Create</a>
                    </form>
            </div>

        </div>
    </div>
</div>



<div class="modal fade mt-5" id="addTicketForSupport" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>CREATE TICKET</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=SUPPORT&action=CREATETICKET">
                       <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Ticket:</label>
                            </div>
                            <div class="col-sm-12">
                                <select class="form-control" name="level" required="">
                                    <option value="1">High</option>  
                                    <option value="2">Medium</option>    
                                    <option value="3">Low</option>    
                                </select>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Subject:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="subject" class="form-control"/>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Concern:</label>
                            </div>
                            <div class="col-sm-12">
                                <textarea col="5" name="concern" rows="5" class="form-control" required=""></textarea>
                            </div>
                        </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Create</a>
                    </form>
            </div>

        </div>
    </div>
</div>

<div class="modal fade mt-5" id="addService" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>CREATE SERVICE</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=SERVICE&action=CREATESERVICE">
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Account:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="account" class="form-control"/>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Description:</label>
                            </div>
                            <div class="col-sm-12">
                                <textarea col="5" name="description" rows="5" class="form-control" required=""></textarea>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Amount:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="number" name="amount" class="form-control"/>
                            </div>
                        </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Create</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<div class="modal fade mt-5" id="addTicketResponseForSupport" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>CREATE TICKET RESPONSE</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=SUPPORT&action=CREATETICKETRESPONSE">
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Ticket:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="ticketid" value="<?php echo $ticketid; ?>" class="form-control" readonly/>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Response:</label>
                            </div>
                            <div class="col-sm-12">
                                <textarea col="5" name="response" rows="5" class="form-control" required=""></textarea>
                            </div>
                        </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Create</a>
                    </form>
            </div>

        </div>
    </div>
</div>