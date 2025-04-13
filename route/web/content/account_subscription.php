

           <!-- Contact Section -->
           <section class="contact section">

           <div class="container text-center" data-aos="fade-up" data-aos-delay="100">
                <h1>Welcome Online Clinic Systems</h1>
                <h5>HI! <?php echo strtoupper($_GET['email']); ?></h5>
                <hr />

                <div class="d-flex flex-wrap justify-content-center gap-3">
                    <?php 
                    $accountType = $portCont->clinic_accountTypes();
                    $code = rand(6666, 9999);
                    if (!empty($accountType)) {
                        foreach ($accountType as $key => $accountType) {
                        include('assets/payment/Grabpay.php');  
                        include('assets/payment/Gpay.php');      
                    ?>
                    <div class="card" style="width: 18rem;">
                        <div class="card-body">
                            <h4 class="card-title"><?php echo $accountType['account']; ?></h4>
                            <h5 class="card-title">Monthly Fee : ₱ <?php echo $accountType['amount']; ?></h5>
                            <p class="card-text">
                               <?php echo $accountType['description']; ?>
                            </p>
                            <!--  $checkoutUrlGrabPay; checkoutUrlGcash -->
                            <a href="?view=SUBSCRIPTIONPAYMENT&action=PAYNOW&method=grabpay&url=<?php echo urlencode($checkoutUrlGrabPay); ?>&trans_id=<?php echo $sourceId; ?>&code=<?php echo $code; ?>&email=<?php echo $_GET['email']; ?>&account_type=<?php  echo $accountType['account_type'];  ?>" class="btn btn-primary w-100" style="background-image:url('assets/payment/logo/grabpay.png'); background-size: contain; 
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
                            <a href="?view=SUBSCRIPTIONPAYMENT&action=PAYNOW&method=gcash&url=<?php echo urlencode($checkoutUrlGcash); ?>&trans_id=<?php echo $sourceId; ?>&code=<?php echo $code; ?>&email=<?php echo $_GET['email']; ?>&account_type=<?php  echo $accountType['account_type'];  ?>" class="btn btn-primary w-100" style="background-image:url('assets/payment/logo/gpay.png'); background-size: contain; 
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
                    </div>
                    <?php } } ?>
                </div>
            </div>


           </section><!-- /Contact Section -->