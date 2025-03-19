<?php 
include('../../connection/connection.php');

class userController extends DBController
{
    function myAccountPatient($client_id)
    {
        $query = "CALL clinic_patient_accountLogin(?)";
         
         $params = array(
             array(
                 "param_type" => "i",
                 "param_value" => $client_id
             )
         );
         
         $account = $this->getDBResult($query, $params);
         return $account;
     }

    function myAccountStaff($user_id)
    {
        $query = "CALL clinic_staff_accountLogin(?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $user_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
    }

    function myAccount($session_id)
    {
        $query = "CALL clinic_business_accountLogin(?)";
         
         $params = array(
             array(
                 "param_type" => "i",
                 "param_value" => $session_id
             )
         );
         
         $account = $this->getDBResult($query, $params);
         return $account;
     }

     function createRoles($account_id,$role_name)
     {
        $query = "CALL clinic_business_role(?,?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "s",
                "param_value" => $role_name
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function clinic_business_account_roles($account_id)
     {
        $query = "CALL clinic_business_account_roles(?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }
     function createAccount($account_id,$fullname,$email,$phone,$password,$role)
     {
        $query = "CALL clinic_business_account_userCreation(?,?,?,?,?,?,?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "s",
                "param_value" => $fullname
            ),
            array(
                "param_type" => "s",
                "param_value" => $email
            ),
            array(
                "param_type" => "s",
                "param_value" => $phone
            ),
            array(
                "param_type" => "s",
                "param_value" => md5($password)
            ),
            array(
                "param_type" => "s",
                "param_value" => $password
            ),
            array(
                "param_type" => "i",
                "param_value" => $role
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function myAccountUsers($account_id)
     {
        $query = "CALL clinic_business_myAccountUsers(?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function myAccountPaymentBilling($account_id)
     {
        $query = "CALL clinic_business_myAccountBilling(?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function createAccountIntegrationPayment($account_id,$public_key,$secret_key,$status,$mode)
     {
        $query = "CALL clinic_business_myAccountBillingIntegration(?,?,?,?,?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "s",
                "param_value" => $public_key
            ),
            array(
                "param_type" => "s",
                "param_value" => $secret_key
            ),
            array(
                "param_type" => "s",
                "param_value" => $status
            ),
            array(
                "param_type" => "s",
                "param_value" => $mode
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function myAccountPaymentBillingView($account_id)
     {
        $query = "CALL clinic_business_account_integrationSpecific(?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function createAccountService($account_id,$service)
     {
        $query = "CALL clinic_business_account_services(?,?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "s",
                "param_value" => $service
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function viewAccountService($account_id)
     {
        $query = "CALL clinic_business_account_services_view(?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function myBusinessAccountProduct($account_id, $name, $code, $target_file, $price, $quantity, $status)
     {
        $query = "CALL clinic_business_account_productUpload(?,?,?,?,?,?,?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "s",
                "param_value" => $name
            ),
            array(
                "param_type" => "s",
                "param_value" => $code
            ),
            array(
                "param_type" => "s",
                "param_value" => $target_file
            ),
            array(
                "param_type" => "i",
                "param_value" => $price
            ),
            array(
                "param_type" => "i",
                "param_value" => $quantity
            ),
            array(
                "param_type" => "s",
                "param_value" => $status
            ),
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function myBusinessAccountProductView($account_id)
     {
        $query = "CALL clinic_business_account_product_view(?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function acceptBooking($account_id, $pid, $client_id, $dob, $age, $fullname, $purpose, $purpose_description, $gender, $doa, $fromIns)
     {
        $query = "CALL clinic_businessPatientBookingCreation(?,?,?,?,?,?,?,?,?,?,?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "s",
                "param_value" => $pid
            ),
            array(
                "param_type" => "i",
                "param_value" => $client_id
            ),
            array(
                "param_type" => "s",
                "param_value" => $dob
            ),
            array(
                "param_type" => "i",
                "param_value" => $age
            ),
            array(
                "param_type" => "s",
                "param_value" => $fullname
            ),
            array(
                "param_type" => "s",
                "param_value" => $purpose
            ),
            array(
                "param_type" => "s",
                "param_value" => $purpose_description
            ),
            array(
                "param_type" => "s",
                "param_value" => $gender
            ),
            array(
                "param_type" => "s",
                "param_value" => $doa
            ),
            array(
                "param_type" => "s",
                "param_value" => $fromIns
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function getAllUpcomingAppointmentHistoryForPatient($uid)
     {
        $query = "CALL clinic_businessPatientBookingView(?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $uid
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }


     function getAllUpcomingAppointment($uid, $dateToday)
     {
        $query = "CALL clinic_businessPatientBookingViewUpcoming(?,?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $uid
            ),
            array(
                "param_type" => "s",
                "param_value" => $dateToday
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function getAllUpcomingAppointmentBusiness($account_id,$dateToday)
     {
        $query = "SELECT CBAA.*,CBS.service FROM clinic_business_account_appointment CBAA LEFT JOIN clinic_business_service CBS ON CBAA.purpose = CBS.bsid WHERE CBAA.account_id = ? AND CBAA.schedule_date = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "s",
                "param_value" => $dateToday
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function getAllUpcomingAppointmentBusinessAll($account_id)
     {
        $query = "SELECT CBAA.*,CBS.service FROM clinic_business_account_appointment CBAA LEFT JOIN clinic_business_service CBS ON CBAA.purpose = CBS.bsid WHERE CBAA.account_id = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function getProductByCode($product_code)
     {
         $query = "SELECT * FROM clinic_account_product WHERE code=?";
         
         $params = array(
             array(
                 "param_type" => "s",
                 "param_value" => $product_code
             )
         );
         
         $productResult = $this->getDBResult($query, $params);
         return $productResult;
     }

     function getCartItemByProduct($id, $client_id)
     {
         $query = "SELECT * FROM clinic_account_cart WHERE product_id = ? AND client_id = ?";
         
         $params = array(
             array(
                 "param_type" => "i",
                 "param_value" => $id
             ),
             array(
                 "param_type" => "i",
                 "param_value" => $client_id
             )
         );
         
         $cartResult = $this->getDBResult($query, $params);
         return $cartResult;
     }

     function updateCartQuantity($quantity, $cart_id)
     {
         $query = "UPDATE clinic_account_cart SET  quantity = ? WHERE id= ?";
         
         $params = array(
             array(
                 "param_type" => "i",
                 "param_value" => $quantity
             ),
             array(
                 "param_type" => "i",
                 "param_value" => $cart_id
             )
         );
         
         $this->updateDB($query, $params);
     }

     function addToCart($product_id, $quantity, $client_id, $account_id)
    {
        $query = "INSERT INTO clinic_account_cart (account_id,client_id,product_id,quantity) VALUES (?, ?, ?, ?)";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $client_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $product_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $quantity
            )
        );
        
        $this->insertDB($query, $params);
    }

    function getMemberCartItem($client_id)
    {
        $query = "SELECT clinic_account_product.*, clinic_account_cart.id as cart_id,clinic_account_cart.quantity FROM clinic_account_product, clinic_account_cart WHERE 
            clinic_account_product.id = clinic_account_cart.product_id AND clinic_account_cart.client_id = ?";
    
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $client_id
            )
        );
        
        $cartResult = $this->getDBResult($query, $params);
        return $cartResult;
    }

    function deleteCartItem($cart_id)
    {
        $query = "DELETE FROM clinic_account_cart WHERE id = ?";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $cart_id
            )
        );
        
        $this->updateDB($query, $params);
    }

    function emptyCart($client_id)
    {
        $query = "DELETE FROM clinic_account_cart WHERE client_id = ?";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $client_id
            )
        );
        
        $this->updateDB($query, $params);
    }


}

$portCont = new userController();

?>