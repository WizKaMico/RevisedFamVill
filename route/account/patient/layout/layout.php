 <div class="ui-theme-settings">
     <button type="button" id="TooltipDemo" class="btn-open-options btn btn-warning">
         <i class="fa fa-cog fa-w-16 fa-spin fa-2x"></i>
     </button>
     <div class="theme-settings__inner">
         <div class="scrollbar-container">
             <div class="theme-settings__options-wrapper">
                 <h3 class="themeoptions-heading">Feedback Options
                 </h3>
                 <div class="p-3">
                 <form action="?view=HOME&action=FEEDBACK" method="POST">
                         <div class="mb-3">
                             <label for="purpose" class="form-label">Appointment Code:</label>
                             <select name="pid" class="form-control" required="">
                                 <option value="">CHOOSE APPOINTMENT CODE</option>
                                 <?php
                                 $uid = $account[0]['client_id'];
                                        $appointment = $portCont->getAllUpcomingAppointmentHistoryForPatient($uid);
                                        if (!empty($appointment)) {
                                            foreach ($appointment as $key => $appointment) {
                                 ?>
                                    <option value="<?php echo $appointment['pid']; ?> "><?php echo $appointment['pid']; ?> | <?php echo $appointment['fullname']; ?></option>
                                    <?php } } ?> 
                             </select>
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
                         <div class="mb-3">
                             <button type="submit" name="submit" class="btn btn-primary w-100">Submit</button>
                         </div>
                     </form>
                 </div>
             </div>
         </div>
     </div>
 </div>