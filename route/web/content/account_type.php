

           <!-- Contact Section -->
           <section class="contact section">

               <div class="container" data-aos="fade-up" data-aos-delay="100">
                   <center>
                       <div class="col-6 col-lg-6">
                           <form action="?view=ACCOUNTTYPE&action=ACCOUNTTYPE"  enctype="multipart/form-data" method="post" class="email-form"
                               data-aos="fade-up" data-aos-delay="500">
                               <div class="row gy-4">
                                  <center>
                                    <h1>Online Clinic Systems</h1>
                                  </center>
                                   <h5>HI! <?php echo strtoupper($_GET['email']); ?></h5>

                                   <input type="hidden" name="email" class="form-control"
                                       value="<?php echo $_GET['email']; ?>" required="">

                                    <div class="row mb-3">
                                        <div class="col-md-12">
                                            <label for="business_ownership" class="form-label d-block text-start"><b>Business Ownership Type</b></label>
                                            <select class="form-control" name="business_ownership" id="business_ownership" require="">
                                                 <option value="Sole Proprietor">Sole Proprietor</option>
                                                 <option value="Partnership">Partnership</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-12">
                                            <label for="business_cert" class="form-label d-block text-start"><b>Business Cert</b></label>
                                            <input type="file" class="form-control" name="business_cert" id="business_cert" required>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-12">
                                            <label for="business_tin" class="form-label d-block text-start"><b>Business Tin</b></label>
                                            <input type="text" class="form-control" name="business_tin" id="business_tin" placeholder="Business Tin" required>
                                        </div>
                                    </div>

                                   <div class="col-md-12 text-center">
                                       <input type="submit" type="submit" name="submit" value="Verify Account"
                                           class="btn btn-primary w-100" style="background-color:#3fbbc0; border:none;">
                                   </div>

                               </div>
                           </form>
                       </div><!-- End Contact Form -->
                   </center>
               </div>

           </section><!-- /Contact Section -->