<?php 

include('../connection/connection.php');

class chartsApiController extends DBController
{

    function profitChartToday($account_id)
    {
        date_default_timezone_set('Asia/Manila');
       
        $query = " SELECT method, COUNT(*) AS count
                FROM (
                    SELECT DISTINCT aid, method
                    FROM clinic_business_my_appointment_payment
                    WHERE date_created = ? AND account_id = ?
                ) AS unique_aid
                GROUP BY method;";
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => date('Y-m-d')
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }

    function appointmentChartToday($account_id)
    {
        date_default_timezone_set('Asia/Manila');
        $query = "SELECT status, count(*) as count FROM clinic_business_account_appointment WHERE date_created = ? AND account_id = ? GROUP BY status";
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => date('Y-m-d')
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }

    function appointmentChartTodayBar($account_id)
    {
        date_default_timezone_set('Asia/Manila');
        $query = "SELECT subject, count(*) as count FROM clinic_business_account_inquiry WHERE date_created = ? AND account_id = ? GROUP BY subject";
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => date('Y-m-d')
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }

    function accountChartToday($account_id)
    {
        date_default_timezone_set('Asia/Manila');
        $query = "SELECT status, count(*) as count FROM clinic_bussiness_account_users WHERE date_created = ? AND account_id = ? GROUP BY status;";
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => date('Y-m-d')
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }


    function appointmentChartOverall($account_id)
    {
        date_default_timezone_set('Asia/Manila');
        $query = "SELECT status, count(*) as count FROM clinic_business_account_appointment WHERE account_id = ? GROUP BY status";
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }

    function ChartOverallTicket()
    {
        date_default_timezone_set('Asia/Manila');
        $query = "SELECT subject, count(*) as count FROM clinic_business_service_ticket GROUP BY subject";
        $result = $this->getDBResult($query);
        return $result;
    }

    function ChartOverallBusiness()
    {
        date_default_timezone_set('Asia/Manila');
        $query = "SELECT status, count(*) as count FROM clinic_business_account GROUP BY status";
        $result = $this->getDBResult($query);
        return $result;
    }

    function ChartOverallInquiry()
    {
        date_default_timezone_set('Asia/Manila');
        $query = "SELECT subject, count(*) as count FROM clinic_main_inquiry GROUP BY subject";
        $result = $this->getDBResult($query);
        return $result;
    }

    function ChartOverallPay()
    {
        date_default_timezone_set('Asia/Manila');
        $query = "SELECT paymethod, count(*) as count FROM clinic_business_account_subscription GROUP BY paymethod";
        $result = $this->getDBResult($query);
        return $result;
    }

    function appointmentChartBarOverall($account_id)
    {
        date_default_timezone_set('Asia/Manila');
        $query = "SELECT subject, count(*) as count FROM clinic_business_account_inquiry WHERE account_id = ? GROUP BY subject";
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }

    function profitChartOverall($account_id)
    {
        date_default_timezone_set('Asia/Manila');
        $query = " SELECT method, COUNT(*) AS count
        FROM (
            SELECT DISTINCT aid, method
            FROM clinic_business_my_appointment_payment
            WHERE account_id = ?
        ) AS unique_aid
        GROUP BY method;";
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }

    function accountChartOverall($account_id)
    {
        date_default_timezone_set('Asia/Manila');
        $query = "SELECT status, count(*) as count FROM clinic_bussiness_account_users WHERE account_id = ? GROUP BY status;";
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }

    function myClinicSchedules($account_id)
    {
        $query = "SELECT CBAP.purpose_description AS purpose_description,
        CBAP.aid as aid, CBAP.fullname as patient, CBAP.date_birth as dob, CBAP.age as age, CBAP.gender as gender, CBAP.schedule_date as schedule_date, CBAP.status as status,cbs.service as purpose,CBA.fullname as guardian,CBA.email as email,
        CBADA.diagnosis as diagnosis, CBAU.fullname as doctor, CBAUP.paygrade as amount
        FROM clinic_business_account_patient CBA 
        LEFT JOIN clinic_business_account_appointment CBAP ON CBAP.uid = CBA.client_id 
        LEFT JOIN clinic_business_assigned_doctor_appointment CBADA ON CBADA.aid = CBAP.aid
        LEFT JOIN clinic_bussiness_account_users CBAU ON CBADA.user_id = CBAU.user_id
        LEFT JOIN clinic_bussiness_account_users_paygrade CBAUP ON CBAUP.user_id = CBAU.user_id
        LEFT JOIN clinic_business_service CBS ON CBS.bsid = CBAP.purpose
        WHERE CBA.account_id = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
    }


}

$portCont = new chartsApiController();

?>