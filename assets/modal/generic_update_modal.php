
<!-- INTEGRATION -->

<div class="modal fade mt-5" id="editIntegration_<?php echo $accounts['pid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Edit Integration</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=INTEGRATION&action=UPDATEINTEGRATION">
                    <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Public Key:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="hidden" name="pid" value="<?php echo $accounts['pid']; ?>" class="form-control" required="">
                                <input type="text" name="public_key" class="form-control" value="<?php echo $accounts['public_key']; ?>" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Secret Key:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="secret_key" class="form-control" value="<?php echo $accounts['secret_key']; ?>" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Status:</label>
                            </div>
                            <div class="col-sm-12">
                                <select class="form-control" name="status" required="">
                                    <option value="<?php echo $accounts['status']; ?>"><?php echo $accounts['status']; ?> (CURRENT)</option>
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
                                    <option value="<?php echo $accounts['mode']; ?>"><?php echo $accounts['mode']; ?> (CURRENT)</option>
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
                        class="glyphicon glyphicon-check"></span> Update</a>
                    </form>
            </div>

        </div>
    </div>
</div>



<div class="modal fade mt-5" id="deactivateIntegration_<?php echo $accounts['pid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Deactivate Integration</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=INTEGRATION&action=UPDATEINTEGRATIONSTATUS">
                       <h5 style="text-align:center;">Do you want to Change Integration Status ?</h5> 
                       <input type="hidden" name="pid" value="<?php echo $accounts['pid']; ?>" class="form-control" required="">
                       <input type="hidden" name="status" value="<?php echo $accounts['status']; ?>" class="form-control" required="">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-warning"><span
                        class="glyphicon glyphicon-check"></span> Deactivate</a>
                    </form>
            </div>

        </div>
    </div>
</div>

<div class="modal fade mt-5" id="deleteIntegration_<?php echo $accounts['pid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Delete Integration</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=INTEGRATION&action=DELETEINTEGRATION">
                      <h5 style="text-align:center;">Do you want to Delete Integration ?</h5>  
                      <input type="hidden" name="pid" value="<?php echo $accounts['pid']; ?>" class="form-control" required="">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-danger"><span
                        class="glyphicon glyphicon-check"></span> Delete</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<!-- INTEGRATION -->

<!-- BILLING  -->
<div class="modal fade mt-5" id="payBILLING_<?php echo $accounts['subs_id']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>ACCOUNT EXTENSION</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                <form method="POST" action="?view=INTEGRATION&action=DELETEINTEGRATION">
                      <h5 style="text-align:center;">You are about to pay ₱ <?php echo $accounts['amount']; ?> | Today <?php echo date('Y-m-d'); ?></h5>  
                      <p style="text-align:center;">Next Bill Will be <?php echo $nextBillingDate; ?></p>
                </div>
                <a href="?view=SUBSCRIPTIONPAYMENT&action=PAYNOW&method=grabpay&url=<?php echo urlencode($checkoutUrlGrabPay); ?>&trans_id=<?php echo $sourceId; ?>&code=<?php echo $code; ?>&email=<?php echo $accounts['email']; ?>&account_type=<?php  echo $accounts['account_type'];  ?>" class="btn btn-primary w-100" style="background-image:url('../../assets/payment/logo/grabpay.png'); background-size: contain; 
                            background-position: center; 
                            background-repeat: no-repeat; 
                            color: white; 
                            background-color:white;
                            padding: 15px; 
                            border: 2px solid #00aa4e; 
                            display: flex; 
                            align-items: center; 
                            justify-content: center;"></a>
                            <hr />
                <a href="?view=SUBSCRIPTIONPAYMENT&action=PAYNOW&method=gcash&url=<?php echo urlencode($checkoutUrlGcash); ?>&trans_id=<?php echo $sourceId; ?>&code=<?php echo $code; ?>&email=<?php echo $accounts['email']; ?>&account_type=<?php  echo $accounts['account_type'];  ?>" class="btn btn-primary w-100" style="background-image:url('../../assets/payment/logo/gpay.png'); background-size: contain; 
                            background-position: center; 
                            background-repeat: no-repeat; 
                            color: white; 
                            background-color:white;
                            border: 2px solid #012cb4;
                            padding: 15px; 
                            display: flex; 
                            align-items: center; 
                            justify-content: center;"></a>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                </form>
            </div>

        </div>
    </div>
</div>


<!-- BILLING  -->


<!-- ACCOUNTS -->


<div class="modal fade mt-5" id="editAccounts_<?php echo $accounts['user_id']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Edit Account</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=ACCOUNTS&action=UPDATEACCOUNTS">
                    <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Fullname:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="hidden" name="user_id" value="<?php echo $accounts['user_id']; ?>" class="form-control" required="">
                                <input type="text" name="fullname" class="form-control" value="<?php echo $accounts['fullname']; ?>" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Email:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="email" class="form-control" value="<?php echo $accounts['email']; ?>" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Phone:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="phone" class="form-control" value="<?php echo $accounts['phone']; ?>" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Password:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="password" class="form-control" value="<?php echo $accounts['unhashed']; ?>" required="">
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Role:</label>
                            </div>
                            <div class="col-sm-12">
                                <select class="form-control" name="role" required="">
                                <option value="<?php echo $accounts['role']; ?> "><?php echo $accounts['role_name']; ?> (CURRENT)</option>
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
                        class="glyphicon glyphicon-check"></span> Update</a>
                    </form>
            </div>

        </div>
    </div>
</div>



<div class="modal fade mt-5" id="deactivateAccounts_<?php echo $accounts['user_id']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Deactivate Account</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=ACCOUNTS&action=UPDATEACCOUNTSSTATUS">
                       <h5 style="text-align:center;">Do you want to Change Account Status ?</h5> 
                       <input type="hidden" name="user_id" value="<?php echo $accounts['user_id']; ?>" class="form-control" required="">
                       <input type="hidden" name="status" value="<?php echo $accounts['status']; ?>" class="form-control" required="">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-warning"><span
                        class="glyphicon glyphicon-check"></span> Deactivate</a>
                    </form>
            </div>

        </div>
    </div>
</div>

<div class="modal fade mt-5" id="deleteAccounts_<?php echo $accounts['user_id']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Delete Account</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=ACCOUNTS&action=DELETEACCOUNT">
                      <h5 style="text-align:center;">Do you want to Delete Account ?</h5>  
                      <input type="hidden" name="user_id" value="<?php echo $accounts['user_id']; ?>" class="form-control" required="">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-danger"><span
                        class="glyphicon glyphicon-check"></span> Delete</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<div class="modal fade mt-5" id="paygradeAccounts_<?php echo $accounts['user_id']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Account Rate</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=ACCOUNTS&action=ACCOUNTPAYGRADE">
                    <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Rate ₱:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="hidden" name="user_id" value="<?php echo $accounts['user_id']; ?>" class="form-control" required="">
                                <input type="number" name="paygrade" class="form-control" value="<?php echo $accounts['paygrade']; ?>" required="">
                            </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-primary"><span
                        class="glyphicon glyphicon-check"></span> Add</a>
                    </form>
            </div>

        </div>
    </div>
</div>



<div class="modal fade mt-5" id="deleteServiceRoleAccounts_<?php echo $accounts['sid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Delete Service Role</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=ACCOUNTS&action=DELETESERVICEROLE">
                      <h5 style="text-align:center;">Do you want to Delete Service Role ?</h5>  
                      <input type="hidden" name="sid" value="<?php echo $accounts['sid']; ?>" class="form-control" required="">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-danger"><span
                        class="glyphicon glyphicon-check"></span> Delete</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<!-- ACCOUNTS -->

<!-- SERVICE -->


<div class="modal fade mt-5" id="editService_<?php echo $accounts['bsid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Edit Service</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=SERVICE&action=UPDATESERVICE">
                    <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Service:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="hidden" name="bsid" value="<?php echo $accounts['bsid']; ?>" class="form-control" required="">
                                <input type="text" name="service" class="form-control" value="<?php echo $accounts['service']; ?>" required="">
                            </div>
                    </div>                            
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Update</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<div class="modal fade mt-5" id="deleteService_<?php echo $accounts['bsid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Delete Service</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=SERVICE&action=DELETESERVICE">
                      <h5 style="text-align:center;">Do you want to Delete Service ?</h5>  
                      <input type="hidden" name="bsid" value="<?php echo $accounts['bsid']; ?>" class="form-control" required="">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-danger"><span
                        class="glyphicon glyphicon-check"></span> Delete</a>
                    </form>
            </div>

        </div>
    </div>
</div>



<!-- SERVICE -->

<!-- PATIENT -->

<div class="modal fade mt-5" id="assignDoctorPatient_<?php echo $accounts['aid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Assign Doctor</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=SPECIFICACCOUNTBOOK&action=ASSIGNDOCTOR">
                    <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Role:</label>
                                <input type="hidden" name="aid" value="<?php echo $accounts['aid']; ?>" class="form-control" required="">
                                <input type="hidden" name="client_id" value="<?php echo $_GET['client_id']; ?>" class="form-control" required="">
                            </div>
                            <div class="col-sm-12">
                                <select class="form-control" name="user_id" required="">
                                    <?php 
                                        $staff = $portCont->clinic_business_account_service_employee($account[0]['account_id']);
                                        if (!empty($staff)) {
                                            foreach ($staff as $key => $staff) {
                                    ?>
                                    <option value="<?php echo $staff['user_id']; ?> "><?php echo $staff['fullname']; ?></option>
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
                        class="glyphicon glyphicon-check"></span> Update</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<div class="modal fade mt-5" id="editPatient_<?php echo $accounts['client_id']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Edit Service</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=PATIENT&action=UPDATEPATIENT">
                    <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Fullname:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="hidden" name="client_id" value="<?php echo $accounts['client_id']; ?>" class="form-control" required="">
                                <input type="text" name="fullname" class="form-control" value="<?php echo $accounts['fullname']; ?>" required="">
                            </div>
                    </div>     
                    <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Username:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="username" class="form-control" value="<?php echo $accounts['username']; ?>" required="">
                            </div>
                    </div>   
                    <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Email:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="email" name="email" class="form-control" value="<?php echo $accounts['email']; ?>" required="">
                            </div>
                    </div>  
                    <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Phone:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="number" name="phone" class="form-control" value="<?php echo $accounts['phone']; ?>" required="">
                            </div>
                    </div>  
                    <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Password:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="password" class="form-control" value="<?php echo $accounts['unhashed']; ?>" required="">
                            </div>
                    </div> 
                                        
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Update</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<div class="modal fade mt-5" id="deletePatient_<?php echo $accounts['client_id']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Delete Patient</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=PATIENT&action=DELETEPATIENT">
                      <h5 style="text-align:center;">Do you want to Delete Service ?</h5>  
                      <input type="hidden" name="client_id" value="<?php echo $accounts['client_id']; ?>" class="form-control" required="">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-danger"><span
                        class="glyphicon glyphicon-check"></span> Delete</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<div class="modal fade mt-5" id="ActivePatient_<?php echo $accounts['client_id']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Activate / Deactivate Patient</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=PATIENT&action=ACTIVATEDEACTIVATEPATIENT">
                      <h5 style="text-align:center;">Do you want to Activate or Deactivate the Account ?</h5>  
                      <input type="hidden" name="client_id" value="<?php echo $accounts['client_id']; ?>" class="form-control" required="">
                      <input type="hidden" name="status" value="<?php echo $accounts['status']; ?>" class="form-control" required="">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-warning"><span
                        class="glyphicon glyphicon-check"></span> Execute</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<div class="modal fade mt-5" id="payBILLINGAppointmentCharge_<?php echo $accounts['aid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>APPOINTMENT BILL PAYMENT</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                <form method="POST" action="?view=INTEGRATION&action=DELETEINTEGRATION">
                      <h5 style="text-align:center;">You are about to pay ₱ <?php echo $accounts['amount']; ?> | Today <?php echo date('Y-m-d'); ?></h5>  
                </div>
                <a href="?view=SPECIFICACCOUNTBOOK&action=PAYNOWAPPOINTMENTBILL&method=grabpay&url=<?php echo urlencode($checkoutUrlGrabPay); ?>&trans_id=<?php echo $sourceId; ?>&code=<?php echo $code; ?>&email=<?php echo $accounts['email']; ?>&aid=<?php echo $accounts['aid']; ?>&client_id=<?php echo $_GET['client_id']; ?>" class="btn btn-primary w-100" style="background-image:url('../../assets/payment/logo/grabpay.png'); background-size: contain; 
                            background-position: center; 
                            background-repeat: no-repeat; 
                            color: white; 
                            background-color:white;
                            padding: 15px; 
                            border: 2px solid #00aa4e; 
                            display: flex; 
                            align-items: center; 
                            justify-content: center;"></a>
                            <hr />
                <a href="?view=SPECIFICACCOUNTBOOK&action=PAYNOWAPPOINTMENTBILL&method=gcash&url=<?php echo urlencode($checkoutUrlGcash); ?>&trans_id=<?php echo $sourceId; ?>&code=<?php echo $code; ?>&email=<?php echo $accounts['email']; ?>&aid=<?php echo $accounts['aid']; ?>&client_id=<?php echo $_GET['client_id']; ?>" class="btn btn-primary w-100" style="background-image:url('../../assets/payment/logo/gpay.png'); background-size: contain; 
                            background-position: center; 
                            background-repeat: no-repeat; 
                            color: white; 
                            background-color:white;
                            border: 2px solid #012cb4;
                            padding: 15px; 
                            display: flex; 
                            align-items: center; 
                            justify-content: center;"></a>
                            <hr />
                    <a href="?view=SPECIFICACCOUNTBOOK&action=PAYNOWAPPOINTMENTBILL&method=cash_payment&code=<?php echo $code; ?>&email=<?php echo $accounts['email']; ?>&aid=<?php echo $accounts['aid']; ?>&client_id=<?php echo $_GET['client_id']; ?>" class="btn btn-primary w-100" style="background-image:url('../../assets/payment/logo/cashlogo.png'); background-size: contain; 
                            background-position: center; 
                            background-repeat: no-repeat; 
                            color: white; 
                            background-color:white;
                            border: 2px solid #012cb4;
                            padding: 15px; 
                            display: flex; 
                            align-items: center; 
                            justify-content: center;"></a>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                </form>
            </div>

        </div>
    </div>
</div>





<div class="modal fade mt-5" id="updateStatus_<?php echo $accounts['aid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Update Patient Appointment Status</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=SPECIFICACCOUNTBOOK&action=APPOINTMENTSTATUSUPDATE">
                    <input type="hidden" name="client_id" value="<?php echo $_GET['client_id']; ?>" class="form-control" required="">
                    <input type="hidden" name="aid" value="<?php echo $accounts['aid']; ?>" class="form-control" required="">
                    <select class="form-control" name="status" required="">
                      <option value="<?php echo $accounts['status']; ?> "><?php echo $accounts['status']; ?> (CURRENT)</option>
                      <option value="BOOKED">BOOKED</option>
                      <option value="CONFIRMED">CONFIRMED</option>
                      <option value="PAYED PENDING">PAYED PENDING</option>
                      <option value="PAYED CONFIRM">PAYED CONFIRM</option>
                      <option value="COMPLETED">COMPLETED</option>
                      <option value="CANCELLED">CANCELLED</option>
                     </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-warning"><span
                        class="glyphicon glyphicon-check"></span> Execute</a>
                    </form>
            </div>

        </div>
    </div>
</div>




<!-- PATIENT -->


<!-- ANNOUNCEMENT -->

<div class="modal fade mt-5" id="editAnnouncement_<?php echo $accounts['announcement_id']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Update Announcement</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=ANNOUNCEMENT&action=UPDATEANNOUNCEMENT">
                    <input type="hidden" name="announcement_id" value="<?php echo $accounts['announcement_id']; ?>" class="form-control" required="">
                    <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Title :</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="announcement_title" class="form-control" value="<?php echo $accounts['announcement_title']; ?>" required="">
                            </div>
                        </div>
                    <div class="row form-group">
                        <div class="col-sm-12">
                            <label class="control-label modal-label">Content :</label>
                        </div>
                        <div class="col-sm-12">
                            <textarea name="announcement_content" rows="5" class="form-control" required><?php echo htmlspecialchars(trim($accounts['announcement_content'])); ?></textarea>
                        </div>
                     </div>
                     <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Status:</label>
                            </div>
                            <div class="col-sm-12">
                                <select class="form-control" name="status" required="">
                                    <option value="<?php echo $accounts['status']; ?>"><?php echo $accounts['status']; ?> (CURRENT)</option>
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
                        class="glyphicon glyphicon-check"></span> Submit</a>
                    </form>
            </div>

        </div>
    </div>
</div>



<div class="modal fade mt-5" id="deleteAnnouncement_<?php echo $accounts['announcement_id']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Delete Announcement</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=ANNOUNCEMENT&action=DELETEANNOUNCEMENT">
                    <h5 style="text-align:center;">Are you sure you want delete this announcement</h5>
                    <input type="hidden" name="announcement_id" value="<?php echo $accounts['announcement_id']; ?>" class="form-control" required="">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-danger"><span
                        class="glyphicon glyphicon-check"></span> Delete</a>
                    </form>
            </div>

        </div>
    </div>
</div>



<!-- ANNOUNCEMENT -->



<!-- PATIENT -->


<div class="modal fade mt-5" id="editAppointment_<?php echo $accounts['aid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Reschedule Appointment</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=HOME&action=UPDATEAPPOINTMENTSCHEDULE">
                    <input type="hidden" name="aid" value="<?php echo $accounts['aid']; ?>" class="form-control" required="">
                    <div class="row form-group">
                        <div class="col-sm-12">
                            <label class="control-label modal-label">Reschedule Date :</label>
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
                        class="glyphicon glyphicon-check"></span> Update</a>
                    </form>
            </div>

        </div>
    </div>
</div>

<div class="modal fade mt-5" id="informationAppointment_<?php echo $accounts['aid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Edit Information</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=HOME&action=UPDATEAPPOINTMENTINFORMATION">
                    <input type="hidden" name="aid" value="<?php echo $accounts['aid']; ?>" class="form-control" required="">
                    <div class="row form-group">
                        <div class="col-sm-12">
                            <label class="control-label modal-label">Fullname :</label>
                        </div>
                        <div class="col-sm-12">
                           <input type="text" name="fullname" value="<?php echo $accounts['fullname']; ?>" class="form-control"/>
                        </div>
                     </div>
                     <div class="row form-group">
                        <div class="col-sm-12">
                            <label class="control-label modal-label">Purpose :</label>
                        </div>
                        <div class="col-sm-12">
                            <select name="purpose" class="form-control" required="">
                                 <?php 
                                        $accounts_ = $portCont->viewAccountService($account_id);
                                        if (!empty($accounts_)) {
                                            foreach ($accounts_ as $key => $accounts_) {
                                                if($accounts['purpose'] == $accounts_['bsid']){
                                 ?>
                                    <option value="<?php echo $accounts_['bsid']; ?> "><?php echo $accounts_['service']; ?> (CURRENT)</option>
                                 <?php } else { ?>
                                    <option value="<?php echo $accounts_['bsid']; ?> "><?php echo $accounts_['service']; ?></option>
                                 <?php } ?>
                                <?php } } ?> 
                             </select>
                        </div>
                     </div>
                     <div class="row form-group">
                        <div class="col-sm-12">
                            <label class="control-label modal-label">Purpose Description :</label>
                        </div>
                        <div class="col-sm-12">
                           <textarea cols="5" rows="10" class="form-control" name="purpose_description"><?php echo $accounts['purpose_description']; ?></textarea>
                        </div>
                     </div>
                     <div class="row form-group">
                        <div class="col-sm-12">
                            <label class="control-label modal-label">Gender :</label>
                        </div>
                        <div class="col-sm-12">
                            <select name="gender" class="form-control" required="">
                                 <option value="<?php echo $accounts['gender']; ?>"><?php echo $accounts['gender']; ?> (CURRENT)</option>
                                 <option value="MALE">MALE</option>
                                 <option value="FEMALE">FEMALE</option>
                             </select>
                        </div>
                     </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Update</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<div class="modal fade mt-5" id="cancelBookingPatientAppointment_<?php echo $accounts['aid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Delete Appointment</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=HOME&action=DELETEAPPOINTMENTINFORMATION">
                    <input type="hidden" name="aid" value="<?php echo $accounts['aid']; ?>" class="form-control" required="">
                    <h5 style="text-align:center;">Are you sure you want to delete this appointment ?</h5>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-danger"><span
                        class="glyphicon glyphicon-check"></span> Delete</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<div class="modal fade mt-5" id="payBILLINGAppointmentChargePatient_<?php echo $accounts['aid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>APPOINTMENT BILL PAYMENT</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                <form method="POST" action="?view=HOME&action=PAYAPPOINTMENT">
                      <h5 style="text-align:center;">You are about to pay ₱ <?php echo $accounts['amount']; ?> | Today <?php echo date('Y-m-d'); ?></h5>  
                </div>
                <a href="?view=HOME&action=PAYAPPOINTMENT&method=grabpay&url=<?php echo urlencode($checkoutUrlGrabPay); ?>&trans_id=<?php echo $sourceId; ?>&code=<?php echo $code; ?>&email=<?php echo $accounts['email']; ?>&aid=<?php echo $accounts['aid']; ?>" class="btn btn-primary w-100" style="background-image:url('../../assets/payment/logo/grabpay.png'); background-size: contain; 
                            background-position: center; 
                            background-repeat: no-repeat; 
                            color: white; 
                            background-color:white;
                            padding: 15px; 
                            border: 2px solid #00aa4e; 
                            display: flex; 
                            align-items: center; 
                            justify-content: center;"></a>
                            <hr />
                <a href="?view=HOME&action=PAYAPPOINTMENT&method=gcash&url=<?php echo urlencode($checkoutUrlGcash); ?>&trans_id=<?php echo $sourceId; ?>&code=<?php echo $code; ?>&email=<?php echo $accounts['email']; ?>&aid=<?php echo $accounts['aid']; ?>" class="btn btn-primary w-100" style="background-image:url('../../assets/payment/logo/gpay.png'); background-size: contain; 
                            background-position: center; 
                            background-repeat: no-repeat; 
                            color: white; 
                            background-color:white;
                            border: 2px solid #012cb4;
                            padding: 15px; 
                            display: flex; 
                            align-items: center; 
                            justify-content: center;"></a>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                </form>
            </div>

        </div>
    </div>
</div>


<!-- PATIENT -->


<div class="modal fade mt-5" id="followupAppointmentReschedule_<?php echo $accounts['fid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Reschedule Appointment</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=HOME&action=UPDATEFOLLOWUPAPPOINTMENTSCHEDULE">
                    <input type="hidden" name="fid" value="<?php echo $accounts['fid']; ?>" class="form-control" required="">
                    <input type="hidden" name="aid" class="form-control" value="<?php echo $_GET['aid']; ?>" required="" readonly="">
                    <input type="hidden" name="client_id" class="form-control" value="<?php echo $_GET['client_id']; ?>" required="" readonly="">
                    <div class="row form-group">
                        <div class="col-sm-12">
                            <label class="control-label modal-label">Reschedule Date :</label>
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
                        class="glyphicon glyphicon-check"></span> Update</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<div class="modal fade mt-5" id="followupAppointmentDiagnosis_<?php echo $accounts['fid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Diagnosis</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=HOME&action=UPDATEFOLLOWUPAPPOINTMENTDIAGNOSIS">
                    <input type="hidden" name="fid" value="<?php echo $accounts['fid']; ?>" class="form-control" required="">
                    <input type="hidden" name="aid" class="form-control" value="<?php echo $_GET['aid']; ?>" required="" readonly="">
                    <input type="hidden" name="client_id" class="form-control" value="<?php echo $_GET['client_id']; ?>" required="" readonly="">
                    <div class="row form-group">
                        <div class="col-sm-12">
                            <label class="control-label modal-label">Diagnosis :</label>
                        </div>
                        <div class="col-sm-12">
                           <textarea cols="5" rows="10" class="form-control" name="diagnosis"><?php echo $accounts['diagnosis']; ?></textarea>
                        </div>
                     </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Update</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<div class="modal fade mt-5" id="followupAppointmentStatus_<?php echo $accounts['fid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Diagnosis</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=HOME&action=UPDATEFOLLOWUPAPPOINTMENTSTATUS">
                    <input type="hidden" name="fid" value="<?php echo $accounts['fid']; ?>" class="form-control" required="">
                    <input type="hidden" name="aid" class="form-control" value="<?php echo $_GET['aid']; ?>" required="" readonly="">
                    <input type="hidden" name="client_id" class="form-control" value="<?php echo $_GET['client_id']; ?>" required="" readonly="">
                    <div class="row form-group">
                        <div class="col-sm-12">
                            <label class="control-label modal-label">Status :</label>
                        </div>
                        <div class="col-sm-12">
                            <select class="form-control" name="status" required="">
                                <option value="<?php echo $accounts['status']; ?> "><?php echo $accounts['status']; ?> (CURRENT)</option>
                                <option value="BOOKED">BOOKED</option>
                                <option value="CONFIRMED">CONFIRMED</option>
                                <option value="PAYED PENDING">PAYED PENDING</option>
                                <option value="PAYED CONFIRM">PAYED CONFIRM</option>
                                <option value="COMPLETED">COMPLETED</option>
                                <option value="CANCELLED">CANCELLED</option>
                            </select>
                        </div>
                     </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Update</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<div class="modal fade mt-5" id="editTicket_<?php echo $accounts['ticketid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Update Support Ticket</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=HOME&action=UPDATESUPPORTTICKET">
                    <input type="hidden" name="ticketid" value="<?php echo $accounts['ticketid']; ?>" class="form-control" required="">
                    <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Ticket:</label>
                            </div>
                            <div class="col-sm-12">
                                <select class="form-control" name="level" required="">
                                    <option value="<?php echo $accounts['level']; ?>">Priority <?php echo $accounts['level']; ?> (CURRENT)</option>
                                    <option value="1">Priority 1</option>  
                                    <option value="2">Priority 2</option>    
                                    <option value="3">Priority 3</option>
                                    <option value="4">Priority 4</option>
                                    <option value="5">Priority 5</option>    
                                </select>
                            </div>
                        </div>
                    <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Subject:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="text" name="subject" class="form-control" value="<?php echo $accounts['subject']; ?>"/>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Concern:</label>
                            </div>
                            <div class="col-sm-12">
                                <textarea col="5" name="concern" rows="5" class="form-control" required=""><?php echo $accounts['concern']; ?></textarea>
                            </div>
                        </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Update</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<div class="modal fade mt-5" id="editTicketAdmin_<?php echo $accounts['ticketid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Update Support Ticket</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=HOME&action=UPDATESUPPORTTICKET">
                    <input type="hidden" name="ticketid" value="<?php echo $accounts['ticketid']; ?>" class="form-control" required="">
                    <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Ticket:</label>
                            </div>
                            <div class="col-sm-12">
                                <select class="form-control" name="level" required="">
                                    <option value="<?php echo $accounts['level']; ?>">Priority <?php echo $accounts['level']; ?> (CURRENT)</option>
                                    <option value="1">High</option>  
                                    <option value="2">Medium</option>    
                                    <option value="3">Low</option>       
                                </select>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Status:</label>
                            </div>
                            <div class="col-sm-12">
                                <select class="form-control" name="status" required="">
                                    <option value="<?php echo $accounts['status']; ?>"><?php echo $accounts['status']; ?> (CURRENT)</option>
                                    <option value="SUBMITTED">SUBMITTED</option>  
                                    <option value="IN-PROGRESS">IN-PROGRESS</option>    
                                    <option value="COMPLETED">COMPLETED</option>
                                </select>
                            </div>
                        </div>               
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Update</a>
                    </form>
            </div>

        </div>
    </div>
</div>




<div class="modal fade mt-5" id="deleteTicket_<?php echo $accounts['ticketid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Delete Support Ticket</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=HOME&action=DELETESUPPORTTICKET">
                    <input type="hidden" name="ticketid" value="<?php echo $accounts['ticketid']; ?>" class="form-control" required="">
                    <h5> Are you sure you want to delete the ticket ? </h5>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Update</a>
                    </form>
            </div>

        </div>
    </div>
</div>




<div class="modal fade mt-5" id="businessInteruption_<?php echo $accounts['account_id']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Activate / Deactivate Account</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=BUSINESS&action=ACTIVATEDEACTIVATEBUSINESS">
                    <input type="hidden" name="account_id" value="<?php echo $accounts['account_id']; ?>" class="form-control" required="">
                    <h5 style="text-align:center;"> Are you sure you want to Activate / Deactivate the Account ? </h5>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Activate / Deactivate</a>
                    </form>
            </div>

        </div>
    </div>
</div>


<div class="modal fade mt-5" id="editServiceCreation_<?php echo $accounts['account_type']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>UPDATE SERVICE</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=SERVICE&action=UPDATESERVICE">
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Account:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="hidden" name="account_type" value="<?php echo $accounts['account_type']; ?>" class="form-control"/>
                                <input type="text" name="account" value="<?php echo $accounts['account']; ?>" class="form-control"/>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Description:</label>
                            </div>
                            <div class="col-sm-12">
                                <textarea col="5" name="description" rows="5" class="form-control" required=""><?php echo $accounts['description']; ?></textarea>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-sm-12">
                                <label class="control-label modal-label">Amount:</label>
                            </div>
                            <div class="col-sm-12">
                                <input type="number" name="amount" value="<?php echo $accounts['amount']; ?>" class="form-control"/>
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


<div class="modal fade mt-5" id="deleteServiceCreation_<?php echo $accounts['account_type']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Delete Service</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form method="POST" action="?view=SERVICE&action=DELETESERVICE">
                    <input type="hidden" name="account_type" value="<?php echo $accounts['account_type']; ?>" class="form-control" required="">
                    <h5 style="text-align:center;"> Are you sure you want to Delete the Service ? </h5>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-danger"><span
                        class="glyphicon glyphicon-check"></span> Delete</a>
                    </form>
            </div>

        </div>
    </div>
</div>

<div class="modal fade mt-5" id="addUpdateComment_<?php echo $value['aid']; ?>" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5>Add Comment</h5>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                <form action="?view=HISTORY&action=FEEDBACK" method="POST">
                         <div class="mb-3">
                             <label for="purpose" class="form-label">Appointment Code:</label>
                             <input type="text" name="pid" class="form-control" value="<?php echo $value['pid']; ?>" required="" readonly="">
                         </div>
                         <div class="mb-3">
                             <label for="gender" class="form-label">Rate:</label>
                             <select name="rate" class="form-control" required="">
                                 <option value="">CHOOSE RATE</option>
                                 <option value="1">🌟</option>
                                 <option value="2">🌟🌟</option>
                                 <option value="3">🌟🌟🌟</option>
                                 <option value="4">🌟🌟🌟🌟</option>
                                 <option value="5">🌟🌟🌟🌟🌟</option>
                             </select>
                         </div>
                         <div class="mb-3">
                             <label for="description" class="form-label">Feedback:</label>
                             <textarea cols="5" rows="10" class="form-control" name="feedback"></textarea>
                         </div>
                    
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><span
                        class="glyphicon glyphicon-remove"></span> Cancel</button>
                <button type="submit" name="submit" class="btn btn-success"><span
                        class="glyphicon glyphicon-check"></span> Confirm</a>
                    </form>
            </div>

        </div>
    </div>
</div>

