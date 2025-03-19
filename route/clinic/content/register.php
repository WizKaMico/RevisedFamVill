           <script>
// Function to validate passwords automatically
function validatePasswords() {
    // Get password and confirm password values
    var password = document.getElementById('password').value;
    var confirmPassword = document.getElementById('confirmPassword').value;
    var messageDiv = document.getElementById('message');

    // Compare the passwords
    if (password === confirmPassword && password !== '') {
        messageDiv.textContent = "Passwords match!";
        messageDiv.style.color = "green"; // Success message
    } else if (password !== confirmPassword) {
        messageDiv.textContent = "Passwords do not match!";
        messageDiv.style.color = "red"; // Error message
    } else {
        // If the password fields are empty, hide the message
        messageDiv.textContent = "";
    }
}

// Add event listeners for real-time validation
window.onload = function() {
    document.getElementById('password').addEventListener('input', validatePasswords);
    document.getElementById('confirmPassword').addEventListener('input', validatePasswords);
};
           </script>

           <!-- Contact Section -->
           <section class="contact section">

               <div class="container" data-aos="fade-up" data-aos-delay="100">
                   <center>
                       <div class="col-6 col-lg-6">
                           <form action="?company=<?php echo $account[0]['business_name']; ?>&view=REGISTER&action=REGISTER" method="post" class="email-form"
                               data-aos="fade-up" data-aos-delay="500">
                               <div class="row gy-4">
                                   <center>
                                      <h5><?php echo strtoupper($account[0]['business_name']); ?></h5>
                                   </center>
                                   <div class="col-md-12">
                                       <input type="text" name="username" class="form-control" placeholder="Username"
                                           required="">
                                   </div>

                                   <div class="col-md-12 ">
                                       <input type="email" class="form-control" name="email" placeholder="Email"
                                           required="">
                                   </div>

                                   <div class="col-md-12 ">
                                       <input type="password" id="password" class="form-control" name="password"
                                           placeholder="Password" required="">
                                   </div>
                                   <div class="col-md-12 ">
                                       <input type="password" id="confirmPassword" class="form-control" name="password"
                                           placeholder="Confirm Password" required="">
                                   </div>
                                   <div id="message"></div>
                                   <div class="col-md-12 ">
                                       <input type="text" class="form-control" name="fullname" placeholder="Fullname"
                                           required="">
                                   </div>

                                   <div class="col-md-12 ">
                                       <input type="number" class="form-control" name="phone" placeholder="Contact"
                                           required="">
                                   </div>

                                   <div class="col-md-12 text-center">
                                       <input type="submit" type="submit" name="submit" value="Create Account"
                                           class="btn btn-primary w-100" style="background-color:#3fbbc0; border:none;">
                                       <hr />
                                       <a href="?company=<?php echo $account[0]['business_name']; ?>&view=LOGIN" class="btn btn-primary w-100"
                                           style="background-color:#3fbbc0; border:none;">Login</a>
                                   </div>

                               </div>
                           </form>
                       </div><!-- End Contact Form -->
                   </center>
               </div>

           </section><!-- /Contact Section -->