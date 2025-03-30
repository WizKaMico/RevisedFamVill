<?php 
include('./connection/connection.php');

class webController extends DBController
{
    function createBusinessAccount($business, $email, $phone, $region, $province, $city, $barangay, $street)
    {
        $query = "CALL clinic_business_createAccount_preliminary(?,?,?,?,?,?,?,?,?)";
        
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $business
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
                "param_value" => $region
            ),
            array(
                "param_type" => "s",
                "param_value" => $province
            ),
            array(
                "param_type" => "s",
                "param_value" => $city
            ),
            array(
                "param_type" => "s",
                "param_value" => $barangay
            ),
            array(
                "param_type" => "s",
                "param_value" => $street
            ),
            array(
                "param_type" => "i",
                "param_value" => rand(6666,9999)
            )
        );

        $accountCreation = $this->getDBResult($query, $params);
        return $accountCreation;
    }

    function myBusinessAccount($email,$code,$hashed,$password)
    {
        $query = "CALL clinic_business_createAccountPassword_preliminary(?,?,?,?)";
        
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $email
            ),
            array(
                "param_type" => "s",
                "param_value" => $code
            ),
            array(
                "param_type" => "s",
                "param_value" => $hashed
            ),
            array(
                "param_type" => "s",
                "param_value" => $password
            )
        );

        $accountCreation = $this->getDBResult($query, $params);
        return $accountCreation;
    }

    function myBusinessAccountLegality($email, $business_ownership, $target_file, $business_tin)
    {
        $query = "CALL clinic_business_createAccountDocuments_final(?,?,?,?)";
        
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $email
            ),
            array(
                "param_type" => "s",
                "param_value" => $business_ownership
            ),
            array(
                "param_type" => "s",
                "param_value" => $target_file
            ),
            array(
                "param_type" => "s",
                "param_value" => $business_tin
            )
        );

        $accountCreation = $this->getDBResult($query, $params);
        return $accountCreation;
    }

    function clinic_accountTypes()
    {
        $query = "CALL clinic_business_accountTypes";
        $accountType = $this->getDBResult($query);
        return $accountType;
    }

    function paymongo_configuration()
    {
        $query = "CALL clinic_paymongoAccount()";
        $accountType = $this->getDBResult($query);
        return $accountType;
    }


    function myBusinessAccountSubscription($method, $trans_id, $email, $code, $account_type)
    {
        $query = "CALL clinic_business_subscription(?,?,?,?,?)";
        
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $method
            ),
            array(
                "param_type" => "s",
                "param_value" => $trans_id
            ),
            array(
                "param_type" => "s",
                "param_value" => $email
            ),
            array(
                "param_type" => "i",
                "param_value" => $code
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_type
            )
        );

        $accountCreation = $this->getDBResult($query, $params);
        return $accountCreation;
    }

    function myBusinessAccountSubscriptionPaymentValidation($code, $status, $email)
    {
        $query = "CALL clinic_business_subscriptionPaymentValidation(?,?,?)";
        
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $code
            ),
            array(
                "param_type" => "s",
                "param_value" => $status
            ),
            array(
                "param_type" => "s",
                "param_value" => $email
            )
        );

        $accountCreation = $this->getDBResult($query, $params);
        return $accountCreation;
    }

    function myAccountRecovery($email,$code)
    {
        $query = "CALL clinic_businessAccountRecovery(?,?)";
        
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $email
            ),
            array(
                "param_type" => "i",
                "param_value" => $code
            )
        );

        $accountCreation = $this->getDBResult($query, $params);
        return $accountCreation;
    }

    function myBusinessAccountInquiry($name,$email,$subject,$message)
    {
        $query = "CALL clinic_business_inquiry(?,?,?,?)";
        
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $name
            ),
            array(
                "param_type" => "s",
                "param_value" => $email
            ),
            array(
                "param_type" => "s",
                "param_value" => $subject
            ),
            array(
                "param_type" => "s",
                "param_value" => $message
            )
        );

        $accountCreation = $this->getDBResult($query, $params);
        return $accountCreation;
    }

    function faq()
    {
        $query = "CALL clinic_business_faq_view";
        $faqView = $this->getDBResult($query);
        return $faqView;
    }

    function myBusinessAccountLogin($email,$password)
    {
        $query = "CALL clinic_business_login(?,?)";
        
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $email
            ),
            array(
                "param_type" => "s",
                "param_value" => $password
            )
        );

        $accountLogin = $this->getDBResult($query, $params);
        return $accountLogin;
    }

    function myBusinessAccountLoginAdmin($email,$password)
    {
        $query = "SELECT CA.* FROM clinic_admin CA WHERE CA.email = ? AND CA.password = ?";
        
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $email
            ),
            array(
                "param_type" => "s",
                "param_value" => $password
            )
        );

        $accountLogin = $this->getDBResult($query, $params);
        return $accountLogin;
    }

}

$portCont = new webController();

?>