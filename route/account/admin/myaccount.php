<div class="row">
     <div class="col-md-4">
         <div class="main-card mb-3 card">
             <div class="card-header">Account Activity</div>
             <div class="table-responsive">
                <div class="col-md-12 mt-2">
                   <table id="accountBilling" class="align-middle mb-0 table table-borderless table-striped table-hover">
                        <thead>
                            <th>Activity</th>
                            <th>Page</th>
                            <th>Date</th>
                        </thead>
                        <tbody>
                            <?php
                            $accounts = $portCont->myAccountOwnerActivity($account_id);
                            if (!empty($accounts)) {
                                foreach ($accounts as $key => $accounts) {
                                    echo 
                                    "<tr>
                                        <td>".$accounts['account_activity']."</td>   
                                        <td>".$accounts['page']."</td>
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
     <div class="col-md-8">
         <div class="main-card mb-3 card">
             <div class="card-header">Account Information</div>
             <div class="table-responsive">
                 <div class="col-md-12 mt-2">
                     <div class="tab">
                         <button class="tablinks active"
                             onclick="openSetting(event, 'Information')"><span class="fa fa-folder-open-o"></span> Owner Information</button>
                          <button class="tablinks" onclick="openSetting(event, 'Clinic')"><span class="fa fa-info-circle"></span> Clinic Information</button>
                         <button class="tablinks" onclick="openSetting(event, 'Web')"><span class="fa fa-globe"></span> Web</button>
                     </div>

                     <div id="Information" class="tabcontent mb-5" style="display: block;">
                        <center>
                         <h5><span class="fa fa-folder-open-o mt-2"></span> Owner Information</h5>
                        </center>
                         <hr />
                         <form action="#" method="POST">
                             <div class="mb-3 mt-3">
                                 <label for="email" class="form-label">Email:</label>
                                 <input type="email" class="form-control" value="<?php echo $account[0]['email']; ?>" required="" readonly="">
                             </div>
                             <div class="mb-3 mt-3">
                                 <label for="contact" class="form-label">Contact:</label>
                                 <input type="number" class="form-control" value="<?php echo $account[0]['phone']; ?>" required="" readonly="">
                             </div>
                             <div class="mb-3 mt-3">
                                 <label for="address" class="form-label">Region:</label>
                                 <input type="text" class="form-control" value="<?php echo $account[0]['region']; ?>" required="" readonly="">
                             </div>
                             <div class="mb-3 mt-3">
                                 <label for="address" class="form-label">Province:</label>
                                 <input type="text" class="form-control" value="<?php echo $account[0]['province']; ?>" required="" readonly="">
                             </div>
                             <div class="mb-3 mt-3">
                                 <label for="address" class="form-label">City:</label>
                                 <input type="text" class="form-control" value="<?php echo $account[0]['city']; ?>" required="" readonly="">
                             </div>
                             <div class="mb-3 mt-3">
                                 <label for="address" class="form-label">Barangay:</label>
                                 <input type="text" class="form-control" value="<?php echo $account[0]['barangay']; ?>" required="" readonly="">
                             </div>
                             <div class="mb-3 mt-3">
                                 <label for="address" class="form-label">Street:</label>
                                 <input type="text" class="form-control" value="<?php echo $account[0]['street']; ?>" readonly="">
                             </div>
                         </form>
                     </div>

                     <div id="Clinic" class="tabcontent mb-5" style="display: none;">
                       <center>
                         <h5><span class="fa fa-info-circle mt-2"></span> Clinic Information</h5>
                       </center>
                         <hr />
                         <form action="#" method="POST">
                             <div class="mb-3 mt-3">
                                 <label for="email" class="form-label">Business Name:</label>
                                 <input type="text" class="form-control" value="<?php echo $account[0]['business_name']; ?>" required="" readonly="">
                             </div>
                             <div class="mb-3 mt-3">
                                 <label for="contact" class="form-label">Ownership Type:</label>
                                 <input type="text" class="form-control" value="<?php echo $account[0]['business_ownership']; ?>" required="" readonly="">
                             </div>
                             <div class="mb-3 mt-3">
                                 <label for="address" class="form-label">Tin:</label>
                                 <input type="text" class="form-control" value="<?php echo $account[0]['business_tin']; ?>" required="" readonly="">
                             </div>
                         </form>
                     </div>

                     <div id="Web" class="tabcontent mb-5" style="display: none;">
                        <center>
                         <h5><span class="fa fa-globe mt-2"></span> Site</h5>
                        </center>
                         <hr />
                         <div class="mb-3 mt-3">
                           <a href="http://localhost/CLINIC_APP/CLINIC/?company=<?php echo $account[0]['business_name']; ?>" id="copyLink">http://localhost/CLINIC_APP/CLINIC/?company=<?php echo $account[0]['business_name']; ?></a>   
                         </div>
                    </div>
                 </div>
             </div>
         </div>
     </div>
 </div>

<script>
document.getElementById("copyLink").addEventListener("click", function(event) {
    event.preventDefault(); // Prevent navigation
    const url = this.getAttribute("href"); // Get the URL

    navigator.clipboard.writeText(url).then(() => {
        alert("Copied to clipboard: " + url);
    }).catch(err => {
        console.error("Failed to copy: ", err);
    });
});
</script>


 <script>
function openSetting(evt, setting) {
    var i, tabcontent, tablinks;

    // Hide all tab content
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }

    // Remove 'active' class from all tab links
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }

    // Show the clicked tab and add 'active' class to its button
    document.getElementById(setting).style.display = "block";
    evt.currentTarget.className += " active";
}
 </script>

