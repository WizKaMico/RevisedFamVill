        <!-- Contact Section -->
        <section class="contact section">

            <div class="container" data-aos="fade-up" data-aos-delay="100">
                <center>
                    <div class="col-6 col-lg-6">
                        <form action="?company=<?php echo $account[0]['business_name']; ?>&view=STAFFLOGIN&action=STAFFLOGIN" method="post" class="email-form" data-aos="fade-up"
                            data-aos-delay="500">
                            <div class="row gy-4">
                                <center>
                                    <h5><?php echo strtoupper($account[0]['business_name']); ?> | STAFF</h5>
                                </center>
                                <div class="col-md-12">
                                    <input type="email" name="email" class="form-control" placeholder="Email"
                                        required="">
                                </div>

                                <div class="col-md-12 ">
                                    <input type="password" class="form-control" name="password" placeholder="Password"
                                        required="">
                                </div>

                                <div class="col-md-12 text-center">
                                    <input type="submit" type="submit" name="submit" value="Login"
                                        class="btn btn-primary w-100" style="background-color:#3fbbc0; border:none;">
                                    <hr />
                                    <a href="?company=<?php echo $account[0]['business_name']; ?>&view=HOME" class="btn btn-primary w-100"
                                        style="background-color:#3fbbc0; border:none;">Back to Home</a>
                                </div>

                            </div>
                        </form>
                    </div><!-- End Contact Form -->
                </center>
            </div>

        </section><!-- /Contact Section -->