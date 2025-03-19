

           <!-- Contact Section -->
           <section class="contact section">

               <div class="container" data-aos="fade-up" data-aos-delay="100">
                   <center>
                       <div class="col-6 col-lg-6">
                            <div class="row gy-4">
                              <center>
                                <h1>Online Clinic Systems</h1>
                              </center>
                                <h4>HI! <?php echo strtoupper($_GET['email']); ?></h4>
                                <h5>TRANSACTION_ID  : <?php echo $_GET['code']; ?></h5>
                                <center>
                                  <?php if($_GET['status'] == 'PAYED'){ ?>
                                    <img src="./assets/payment/image/confirmed.jpg" style="width:50%;"/>
                                    <a href="?view=LOGIN" class="btn btn-primary w-50" style="background-color:#3fbbc0; border:none;">Login</a>
                                  <?php } else { ?>
                                    <img src="./assets/payment/image/decline.jpg" style="width:50%;"/>  
                                    <a href="?view=SUBSCRIPTIONPAYMENT&email=<?php echo $_GET['email']; ?>" class="btn btn-primary w-50" style="background-color:#3fbbc0; border:none;">Redo Payment</a>
                                  <?php } ?>
                                </center>
                            </div>
                       </div><!-- End Contact Form -->
                   </center>
               </div>

           </section><!-- /Contact Section -->