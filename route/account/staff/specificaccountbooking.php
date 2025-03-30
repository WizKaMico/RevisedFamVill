<?php 
$client_id = $_GET['client_id'];
$specificAccount = $portCont->myClinicSpecificAccountInfo($account_id,$client_id); 
?>
<div class="row">
    <div class="col-md-8">
        <div class="main-card mb-3 card">
            <div class="card-header">APPOINTMENT HISTORY OF <?php echo strtoupper($specificAccount[0]['fullname']); ?></div>
            <div class="table-responsive">
                <div class="col-md-12 mt-2">
                <table id="activityScheduling" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>Patient</th>
                            <th>Age</th>
                            <th>Gender</th>
                            <th>Doctor</th>
                            <th>Rate</th>
                            <th>Schedule</th>
                            <th>Status</th>
                            <th>Purpose</th>
                            <th>Action</th>
                        </thead>
                        <tbody>
                            <?php
                            $account_check = $portCont->myClinicSpecificAccountBooking($account_id,$client_id);
                            if (!empty($account_check)) {
                                foreach ($account_check as $key => $accounts) {
                                    $code = rand(6666, 9999);
                                    echo 
                                    "<tr>
                                        <td>".$accounts['patient']."</td>   
                                        <td>".$accounts['age']."</td>
                                        <td>".$accounts['gender']."</td>
                                        <td>".$accounts['doctor']."</td>
                                        <td>₱ ".$accounts['amount']."</td>
                                        <td>".$accounts['schedule_date']."</td>
                                        <td>".$accounts['status']."</td>
                                        <td>".$accounts['purpose']."</td>";
                                    if($accounts['status'] != 'CANCELLED') {
                                        if(empty($accounts['amount'])){
                                        echo 
                                        "<td>
                                            <a href='#editAppointment_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-calendar'></i></span></a>
                                            <a href='#assignDoctorPatient_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-user-plus'></i></span></a>
                                            <a href='#updateStatus_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-flag'></i></span></a>
                                            <a href='?view=SPECIFICACCOUNTBOOKVIEW&aid=".$accounts['aid']."&client_id=".$client_id."' class='btn btn-success btn-sm'> <i class='fa fa-folder-open'></i></span></a>
                                        </td>";
                                        }else{
                                            if($accounts['status'] == "CONFIRMED" || $accounts['status'] == "PAYED PENDING")
                                            {
                                                echo
                                                "<td>
                                                    <a href='#editAppointment_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-calendar'></i></span></a>
                                                    <a href='#updateStatus_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-flag'></i></span></a>
                                                    <a href='?view=SPECIFICACCOUNTBOOKVIEW&aid=".$accounts['aid']."&client_id=".$client_id."' class='btn btn-success btn-sm'> <i class='fa fa-folder-open'></i></span></a>
                                                </td>";
                                            }else{
                                                echo
                                                "<td>
                                                    <a href='#editAppointment_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-calendar'></i></span></a>
                                                    <a href='#updateStatus_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-flag'></i></span></a>
                                                    <a href='?view=SPECIFICACCOUNTBOOKVIEW&aid=".$accounts['aid']."&client_id=".$client_id."' class='btn btn-success btn-sm'> <i class='fa fa-folder-open'></i></span></a>
                                                </td>";
                                            }
                                        }
                                    }else{
                                        echo
                                        "<td>
                                            <a href='#updateStatus_".$accounts['aid']."' class='btn btn-success btn-sm' data-toggle='modal' data-backdrop='false'> <i class='fa fa-flag'></i></span></a>
                                        </td>";
                                    }

                                    echo "</tr>";
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
    <div class="col-md-4">
        <div class="main-card mb-3 card">
            <div class="card-header">BOOK APPOINTMENT</div>
              <div class="table-responsive">
                <div class="col-md-12 mt-2">
                    <form action="?view=SPECIFICACCOUNTBOOK&action=BOOK" method="POST">
                         <div class="mb-3 mt-3">
                             <label for="fullname" class="form-label">Patient Name:</label>
                             <input type="text" class="form-control" id="fullname" placeholder="Enter Patient Name"
                                 name="fullname">
                                 <input type="hidden" class="form-control" id="contact"
                                 value="<?php echo $specificAccount[0]['client_id']; ?>" name="client_id" readonly="">
                         </div>
                         <div class="mb-3 mt-3">
                             <label for="fullname" class="form-label">Contact:</label>
                             <input type="number" class="form-control" id="contact"
                                 value="<?php echo $specificAccount[0]['phone']; ?>" name="contact" readonly="">
                         </div>
                         <div class="mb-3">
                             <label for="dob" class="form-label">Date of Birth:</label>
                             <input type="date" class="form-control" id="dob" min="2008-01-01" placeholder="Enter Date of Birth"
                                 name="dob">
                         </div>
                         <div class="mb-3">
                             <label for="gender" class="form-label">Gender:</label>
                             <select name="gender" class="form-control" required="">
                                 <option value="">CHOOSE GENDER</option>
                                 <option value="MALE">MALE</option>
                                 <option value="FEMALE">FEMALE</option>
                             </select>
                         </div>
                         <div class="mb-3">
                             <label for="purpose" class="form-label">Purpose of Visit:</label>
                             <select name="purpose" class="form-control" required="">
                                 <option value="">CHOOSE PURPOSE</option>
                                 <?php 
                                        $accounts = $portCont->viewAccountService($account_id);
                                        if (!empty($accounts)) {
                                            foreach ($accounts as $key => $accounts) {
                                 ?>
                                    <option value="<?php echo $accounts['bsid']; ?> "><?php echo $accounts['service']; ?></option>
                                    <?php } } ?> 
                             </select>
                         </div>
                         <div class="mb-3">
                             <label for="description" class="form-label">Purpose of Description:</label>
                             <textarea cols="5" rows="10" class="form-control" name="purpose_description"></textarea>
                         </div>
                         <div class="mb-3">
                             <label for="doa" class="form-label">Date of Appointment:</label>
                             <input type="text" name="doa" class="form-control" id="doa" readonly
                                 placeholder="Enter Date of Appointment">
                             <input type="hidden" name="fromIns" class="form-control" id="fromIns" value="WEB">
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



<script>
  document.addEventListener('DOMContentLoaded', function() {
    const dateInput = document.getElementById('schedule_date');
    const selectedDate = dateInput.value;

    // Set min date = today
    const today = new Date().toISOString().split('T')[0];
    dateInput.setAttribute('min', today);

    // Disable selected date on click
    dateInput.addEventListener('input', function(e) {
      const pickedDate = e.target.value;
      
      // Check if weekend
      const day = new Date(pickedDate).getDay();
      if (day === 6 || day === 0) { // Saturday or Sunday
        alert('Weekend dates are not allowed!');
        e.target.value = '';
        return;
      }

      // Check if same as previous selected date
      if (pickedDate === selectedDate) {
        alert('You cannot select the same date again.');
        e.target.value = '';
        return;
      }
    });
  });
</script>