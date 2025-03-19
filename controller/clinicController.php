<?php 
include('../connection/connection.php');

class clinicController extends DBController
{
    function myBusinessAccount($business_name)
    {
        $query = "CALL clinic_business_account_view(?)";
        
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $business_name
            )
        );

        $accountLogin = $this->getDBResult($query, $params);
        return $accountLogin;
    }

    function aAddAccount($account_id, $fullname, $username, $email, $phone, $password)
    {
        $query = "CALL clinic_patient_AccountCreation (?, ?, ?, ?, ?, ?, ?, ?)";
        $code = rand(666666,999999);
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
                "param_value" => $username
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
                "param_type" => "s",
                "param_value" => $code 
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
    }

    function lSearchAccountVerification($email,$code)
    {
        $query = "CALL clinic_business_patient_accountVerification(?,?)";
        
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

        $accountLogin = $this->getDBResult($query, $params);
        return $accountLogin;
    }

    function lSearchAccount($email)
    {
        $query = "CALL clinic_business_patient_accountForgotPasswordVerification(?,?)";
        $code = rand(666666,999999);
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $email
            ),
            array(
                "param_type" => "s",
                "param_value" => $code
            )
        );
        
        $AccountResult = $this->getDBResult($query, $params);
        return $AccountResult;
    }

    function AccountNewPasswordUpdate($password, $email, $code)
    {
        $query = "CALL clinic_business_patient_accountNewPasswordUpdate(?,?,?,?)";
        
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => md5($password)
            ),
            array(
                "param_type" => "s",
                "param_value" => $password
            ),
            array(
                "param_type" => "s",
                "param_value" => $email
            ),
            array(
                "param_type" => "s",
                "param_value" => $code
            )
        );
        
        $AccountResult = $this->getDBResult($query, $params);
        return $AccountResult;
    }

    function aAddInquiry($account_id, $name, $email, $subject, $message)
    {
        $query = "CALL clinic_business_account_inquiryCreation(?,?,?,?,?)";
        
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
        
        $AccountResult = $this->getDBResult($query, $params);
        return $AccountResult;
    }

    function lSearchAccountLogin($username, $password)
    {
        $query = "CALL clinic_business_account_accountLoginValidation(?,?)";
        
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $username
            ),
            array(
                "param_type" => "s",
                "param_value" => $password
            )
        );
        
        $AccountResult = $this->getDBResult($query, $params);
        return $AccountResult;
    }

    function lSearchAccountLoginStaff($email, $password)
    {
        $query = "CALL clinic_business_account_staffLoginValidation(?,?)";
        
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
        
        $AccountResult = $this->getDBResult($query, $params);
        return $AccountResult;
    }
}

$portCont = new clinicController();

?>