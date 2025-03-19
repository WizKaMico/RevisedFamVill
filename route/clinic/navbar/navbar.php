       <div class="branding d-flex align-items-center">

           <div class="container position-relative d-flex align-items-center justify-content-end">
               <a href="?company=<?php echo strtoupper($account[0]['business_name']); ?>&view=HOME" class="logo d-flex align-items-center me-auto">
                   <h1 class="Online Clinic System" style="color:#3fbbc0;"><?php echo strtoupper($account[0]['business_name']); ?></h1>
               </a>

               <nav id="navmenu" class="navmenu">
                   <ul>
                       <li><a href="#hero" class="active">Home</a></li>
                       <li><a href="#about">About</a></li>
                       <li><a href="#contact">Contact</a></li>
                   </ul>
                   <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
               </nav>

               <a class="cta-btn" href="?company=<?php echo $account[0]['business_name']; ?>&view=LOGIN" style="border-radius:20px; margin-right:-20px;">Login</a>
               <a class="cta-btn" href="?company=<?php echo $account[0]['business_name']; ?>&view=REGISTER" style="border-radius:20px; margin-right:-20px;">Signup</a> 
               <a class="cta-btn" href="?company=<?php echo $account[0]['business_name']; ?>&view=STAFFLOGIN" style="border-radius:20px;">Staff</a> 
           </div>

       </div>