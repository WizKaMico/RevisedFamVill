        <!-- Contact Section -->
        <section class="contact section">

            <div class="container" data-aos="fade-up" data-aos-delay="100">
                <center>
                    <div class="col-6 col-lg-6">
                        <form action="?view=VERIFICATION&action=VERIFY" method="post" class="email-form"
                            data-aos="fade-up" data-aos-delay="500">
                            <div class="row gy-4">
                                <center>
                                    <h1>Online Clinic Systems</h1>
                                </center>
                                <div class="col-md-12">
                                    <h5>HI! <?php echo strtoupper($_GET['email']); ?></h5>
                                    <input type="text" name="code" class="form-control" placeholder="Enter 6-Digit Code"
                                        required="">
                                    <input type="hidden" name="email" class="form-control"
                                        value="<?php echo $_GET['email']; ?>" required="">
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