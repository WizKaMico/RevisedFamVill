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
    
    function myAppointmentBookingFeedback($account_id, $client_id, $pid, $rate, $feedback)
    {
        $query = "INSERT INTO clinic_business_appointment_feedback (account_id, client_id, pid, rate, feedback) VALUES (?,?,?,?,?)";
         
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
                "param_type" => "s",
                "param_value" => $pid
            ),array(
                "param_type" => "s",
                "param_value" => $rate
            ),array(
                "param_type" => "s",
                "param_value" => $feedback
            )
        );
        
        $this->insertDB($query, $params);
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

     function myAccountAdmin($admin_id)
     {
        $query = "SELECT CA.* FROM clinic_admin CA WHERE CA.admin_id = ?";
         
         $params = array(
             array(
                 "param_type" => "i",
                 "param_value" => $admin_id
             )
         );
         
         $account = $this->getDBResult($query, $params);
         return $account;
     }

     function myAccountBussiness()
     {
        $query = "SELECT CBA.*,CBAS.account_type,CAT.account,SUM(CAT.amount) as PAY,CBAS.date_created FROM clinic_business_account CBA
                    LEFT JOIN clinic_business_account_subscription CBAS ON CBA.account_id = CBAS.account_id
                    LEFT JOIN clinic_account_type CAT ON CBAS.account_type = CAT.account_type";
        $account = $this->getDBResult($query);
        return $account;
     }

     function myAccountBussinessAccountService()
     {
        $query = "SELECT CAT.* FROM clinic_account_type CAT";
        $account = $this->getDBResult($query);
        return $account;
     }

     function myAccountBusinessCreationOfService($account,$description,$amount)
     {
        $query = "INSERT INTO clinic_account_type (account, description, amount) VALUES (?,?,?)";
         
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $account
            ),
            array(
                "param_type" => "s",
                "param_value" => $description
            ),
            array(
                "param_type" => "i",
                "param_value" => $amount
            )
        );
        
        $this->insertDB($query, $params);
     }

     function myAccountBusinessCreationOfServiceUpdate($account_type,$account,$description,$amount)
     {
        $query = "UPDATE clinic_account_type SET account = ?, description = ?, amount = ? WHERE account_type = ?";
         
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $account
            ),
            array(
                "param_type" => "s",
                "param_value" => $description
            ),
            array(
                "param_type" => "s",
                "param_value" => $amount
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_type
            )
        );
        $this->updateDB($query, $params);
     }

     function myAccountBusinessCreationOfServiceDelete($account_type)
     {
        $query = "DELETE FROM clinic_account_type WHERE account_type = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_type
            )
        );
        $this->updateDB($query, $params);
     }

     function myAccountClinicInquiry()
     {
        $query = "SELECT CMI.* FROM clinic_main_inquiry CMI";

        $account = $this->getDBResult($query);
        return $account;
     }

     function myAccountBusinessCheck($account_id)
     {
        $query = "SELECT CBA.*,CBAS.account_type,CAT.account,SUM(CAT.amount) as PAY,CBAS.date_created FROM clinic_business_account CBA
                    LEFT JOIN clinic_business_account_subscription CBAS ON CBA.account_id = CBAS.account_id
                    LEFT JOIN clinic_account_type CAT ON CBAS.account_type = CAT.account_type WHERE CBAS.account_id = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function myAccountBusinessAccountActivationDeactivation($account_id,$status)
     {
        $query = "UPDATE clinic_business_account SET status = ? WHERE account_id = ?";
         
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $status
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        $this->updateDB($query, $params);
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

     function createServiceAccount($account_id,$role)
     {
        $query = "INSERT INTO clinic_business_service_account (account_id,role_id) VALUES (?,?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $role
            )
        );
        $this->insertDB($query, $params);
     }

     function deleteServiceAccount($account_id,$sid)
     {
        $query = "DELETE FROM clinic_business_service_account WHERE account_id = ? AND sid = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $sid
            )
        );
        $this->updateDB($query, $params);
     }

     function updateAccount($user_id,$account_id,$fullname,$email,$phone,$password,$role)
     {
        $query = "UPDATE clinic_bussiness_account_users SET fullname = ?, email = ?, phone = ?, password = ?, unhashed = ?, role = ? WHERE user_id = ? AND account_id = ?";
         
        $params = array(
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
            ),
            array(
                "param_type" => "i",
                "param_value" => $user_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $this->updateDB($query, $params);
     }

     function clinic_business_account_service_employee($account_id)
     {
        $query = "SELECT * FROM clinic_business_service_account CBSA LEFT JOIN clinic_bussiness_account_users CBAU ON CBSA.role_id = CBAU.role WHERE cbau.account_id = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function addDoctorAppointAccount($account_id,$user_id,$aid)
     {
        $query = "INSERT INTO clinic_business_assigned_doctor_appointment (account_id,aid,user_id) VALUES (?,?,?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $aid
            ),
            array(
                "param_type" => "i",
                "param_value" => $user_id
            )
        );
        
        $this->insertDB($query, $params);
     }

     function updateAccountStatus($status,$user_id,$account_id)
     {
        $query = "UPDATE clinic_bussiness_account_users SET status = ? WHERE user_id = ? AND account_id = ?";
         
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $status
            ),
            array(
                "param_type" => "i",
                "param_value" => $user_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $this->updateDB($query, $params);
     }

     function deleteAccount($user_id,$account_id)
     {
        $query = "DELETE FROM clinic_bussiness_account_users WHERE user_id = ? AND account_id = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $user_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $this->updateDB($query, $params);
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

     function myAccountUsersService($account_id)
     {
        $query = "SELECT CBSA.sid as sid,CBR.role_name as role_name FROM clinic_business_service_account CBSA LEFT JOIN clinic_business_roles CBR ON CBSA.role_id = CBR.role_id WHERE CBSA.account_id = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function checkPayGradeAccount($user_id,$account_id)
     {
        $query = "SELECT CBAUP.* FROM clinic_bussiness_account_users_paygrade CBAUP WHERE CBAUP.user_id = ? AND CBAUP.account_id = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $user_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function checkPayGradeAccountUpdate($user_id,$account_id,$paygrade)
     {
        $query = "UPDATE clinic_bussiness_account_users_paygrade SET paygrade = ? WHERE user_id = ? AND account_id = ?";
         
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $paygrade
            ),
            array(
                "param_type" => "i",
                "param_value" => $user_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $this->updateDB($query, $params);
     }

     function updateAccountService($account_id,$bsid,$service)
     {
        $query = "UPDATE clinic_business_service SET service = ? WHERE bsid = ? AND account_id = ?";
         
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $service
            ),
            array(
                "param_type" => "i",
                "param_value" => $bsid
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $this->updateDB($query, $params);
     }

     function deleteAccountService($account_id,$bsid)
     {
        $query = "DELETE FROM clinic_business_service WHERE bsid = ? AND account_id = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $bsid
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $this->updateDB($query, $params);
     }

     function checkPayGradeAccountInsert($user_id,$account_id,$paygrade)
     {
        $query = "INSERT INTO clinic_bussiness_account_users_paygrade (user_id,account_id,paygrade) VALUES (?,?,?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $user_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "s",
                "param_value" => $paygrade
            )
        );
        
        $this->insertDB($query, $params);
     }

     function myAnnouncementCreation($account_id, $announcement_title, $announcement_content, $status)
     {
        $query = "INSERT INTO clinic_business_account_announcement (account_id,announcement_title,announcement_content,status) VALUES (?,?,?,?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "s",
                "param_value" => $announcement_title
            ),
            array(
                "param_type" => "s",
                "param_value" => $announcement_content
            ),
            array(
                "param_type" => "s",
                "param_value" => $status
            )
        );
        
        $this->insertDB($query, $params);
     }

     function myAnnouncementUpdate($account_id, $announcement_id, $announcement_title, $announcement_content, $status)
     {
        $query = "UPDATE clinic_business_account_announcement SET announcement_title = ?, announcement_content = ?, status = ? WHERE account_id = ? AND announcement_id = ?";
         
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $announcement_title
            ),
            array(
                "param_type" => "s",
                "param_value" => $announcement_content
            ),
            array(
                "param_type" => "s",
                "param_value" => $status
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $announcement_id
            )
        );
        
        $this->updateDB($query, $params);
     }

     function myAnnouncementDelete($announcement_id)
     {
        $query = "DELETE FROM clinic_business_account_announcement WHERE announcement_id = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $announcement_id
            )
        );
        
        $this->updateDB($query, $params);
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


     function myClinicSchedules($account_id)
     {
        $query = "SELECT 
					DISTINCT
                    CBAP.purpose_description AS purpose_description,
                    CBAP.aid AS aid, 
                    CBAP.fullname AS patient, 
                    CBAP.date_birth AS dob, 
                    CBAP.age AS age, 
                    CBAP.gender AS gender, 
                    CBAP.schedule_date AS schedule_date, 
                    CBAP.status AS status,
                    CBS.service AS purpose,
                    CBA.fullname AS guardian,
                    CBA.email AS email,
                    CBADA.diagnosis AS diagnosis, 
                    CBAU.fullname AS doctor, 
                    CBAUP.paygrade AS amount,
                    CBMAP.method AS payment_method,
                    CBMAP.date_created AS payment_date
                FROM clinic_business_account_patient CBA 
                LEFT JOIN clinic_business_account_appointment CBAP 
                    ON CBAP.uid = CBA.client_id 
                LEFT JOIN clinic_business_assigned_doctor_appointment CBADA 
                    ON CBADA.aid = CBAP.aid
                LEFT JOIN clinic_bussiness_account_users CBAU 
                    ON CBADA.user_id = CBAU.user_id
                LEFT JOIN clinic_bussiness_account_users_paygrade CBAUP 
                    ON CBAUP.user_id = CBAU.user_id
                LEFT JOIN clinic_business_service CBS 
                    ON CBS.bsid = CBAP.purpose
                LEFT JOIN (
                    SELECT *
                    FROM clinic_business_my_appointment_payment cb1
                    WHERE cb1.aid = (
                        SELECT MAX(cb2.aid)
                        FROM clinic_business_my_appointment_payment cb2
                        WHERE cb2.aid = cb1.aid
                    )
                ) CBMAP 
                    ON CBMAP.aid = CBAP.aid
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



     function myClinicSchedulesToday($account_id)
     {
        date_default_timezone_set('Asia/Manila');
        $query = "SELECT 
                CBAP.aid as aid, CBAP.fullname as patient, CBAP.date_birth as dob, CBAP.age as age, CBAP.gender as gender, CBAP.schedule_date as schedule_date, CBAP.status as status,cbs.service as purpose,CBA.fullname as guardian,CBA.email as email,
                CBADA.diagnosis as diagnosis, CBAU.fullname as doctor, CBAUP.paygrade as amount
                FROM clinic_business_account_patient CBA 
                LEFT JOIN clinic_business_account_appointment CBAP ON CBAP.uid = CBA.client_id 
                LEFT JOIN clinic_business_assigned_doctor_appointment CBADA ON CBADA.aid = CBAP.aid
                LEFT JOIN clinic_bussiness_account_users CBAU ON CBADA.user_id = CBAU.user_id
                LEFT JOIN clinic_bussiness_account_users_paygrade CBAUP ON CBAUP.user_id = CBAU.user_id
                LEFT JOIN clinic_business_service CBS ON CBS.bsid = CBAP.purpose
                WHERE CBA.account_id = ? AND CBAP.schedule_date = ?";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "s",
                "param_value" => date('Y-m-d')
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function myClinicSpecificAccountBooking($account_id,$client_id)
     {
        $query = "SELECT CBAP.aid as aid, CBAP.fullname as patient, CBAP.date_birth as dob, CBAP.age as age, CBAP.gender as gender, CBAP.schedule_date as schedule_date, CBAP.status as status,cbs.service as purpose,CBA.fullname as guardian,CBA.email as email,
        CBADA.diagnosis as diagnosis, CBAU.fullname as doctor, CBAUP.paygrade as amount FROM clinic_business_account_patient CBA 
        LEFT JOIN clinic_business_account_appointment CBAP ON CBAP.uid = CBA.client_id 
        LEFT JOIN clinic_business_assigned_doctor_appointment CBADA ON CBADA.aid = CBAP.aid
        LEFT JOIN clinic_bussiness_account_users CBAU ON CBADA.user_id = CBAU.user_id
        LEFT JOIN clinic_bussiness_account_users_paygrade CBAUP ON CBAUP.user_id = CBAU.user_id
        LEFT JOIN clinic_business_service CBS ON CBS.bsid = CBAP.purpose
        WHERE CBA.client_id = ? AND CBA.account_id = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $client_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function myClinicSpecificAccountBookingSpecific($aid,$account_id,$client_id)
     {
        $query = "SELECT CBAP.aid as aid, CBAP.fullname as patient, CBAP.date_birth as dob, CBAP.age as age, CBAP.gender as gender, CBAP.schedule_date as schedule_date, CBAP.status as status,cbs.service as purpose,CBA.fullname as guardian,CBA.email as email,
        CBADA.diagnosis as diagnosis, CBAU.fullname as doctor, CBAUP.paygrade as amount 
        FROM clinic_business_account_patient CBA 
        LEFT JOIN clinic_business_account_appointment CBAP ON CBAP.uid = CBA.client_id 
        LEFT JOIN clinic_business_assigned_doctor_appointment CBADA ON CBADA.aid = CBAP.aid
        LEFT JOIN clinic_bussiness_account_users CBAU ON CBADA.user_id = CBAU.user_id
        LEFT JOIN clinic_bussiness_account_users_paygrade CBAUP ON CBAUP.user_id = CBAU.user_id
        LEFT JOIN clinic_business_service CBS ON CBS.bsid = CBAP.purpose
        WHERE CBAP.aid = ? AND CBA.account_id = ? AND CBA.client_id = ?";

        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $aid
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $client_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function myClinicSpecificAccountBookingSpecificFeedback($aid)
     {
        $query = "SELECT CBAF.* FROM clinic_business_appointment_feedback CBAF LEFT JOIN clinic_business_account_appointment CBAA ON CBAF.pid = CBAA.pid WHERE CBAA.aid = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $aid
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function myAccountInquiryCompany($account_id)
     {
        $query = "SELECT CBAI.* FROM clinic_business_account_inquiry CBAI WHERE CBAI.account_id = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function myAccountAnnouncementCompany($account_id)
     {
        $query = "SELECT CBAA.* FROM clinic_business_account_announcement CBAA WHERE CBAA.account_id = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function myAccountAnnouncementDisplay($account_id)
     {
        $query = "SELECT CBAA.* FROM clinic_business_account_announcement CBAA WHERE CBAA.account_id = ? AND CBAA.status = 'ACTIVE' LIMIT 1";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function myClinicSpecificAccountInfo($account_id,$client_id)
     {
        $query = "SELECT CBAP.* FROM clinic_business_account_patient CBAP WHERE CBAP.client_id = ? AND CBAP.account_id = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $client_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function myPatientAccounts($account_id)
     {
        $query = "SELECT * FROM clinic_business_account_patient  CBAP WHERE CBAP.account_id = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function updatePatient($account_id,$client_id,$fullname,$username,$email,$phone,$password)
     {
        $query = "UPDATE clinic_business_account_patient SET fullname = ?, username = ?, email = ?, phone = ?, password = ?, unhashed = ? WHERE client_id = ? AND account_id = ?";
         
        $params = array(
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
                "param_type" => "i",
                "param_value" => $client_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $this->updateDB($query, $params);
     }

     function update_appointment_diagnosis($aid, $diagnosis)
     {
        $query = "UPDATE clinic_business_assigned_doctor_appointment SET diagnosis = ? WHERE aid = ?";
         
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $diagnosis
            ),
            array(
                "param_type" => "s",
                "param_value" => $aid
            )
        );
        
        $this->updateDB($query, $params);
     }

     function createPatient($account_id,$fullname,$username,$email,$phone,$password)
     {
        $query = "INSERT INTO clinic_business_account_patient (account_id,fullname,username,email,phone,password,unhashed,code) VALUES (?,?,?,?,?,?,?,?)";
         
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
                "param_type" => "i",
                "param_value" => rand(666666,999999)
            )
        );
        
        $this->insertDB($query, $params);
     }

     function addFollowUpSchedule($aid,$account_id,$doctor_id,$schedule_date)
     {
        $query = "INSERT INTO clinic_business_account_appointment_follow_up (aid,account_id,doctor_id,schedule_date) VALUES (?,?,?,?)";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $aid
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $doctor_id
            ),
            array(
                "param_type" => "s",
                "param_value" => $schedule_date
            )
        );
        
        $this->insertDB($query, $params);
     }

     function myPatientAppointmentFollowup($aid)
     {
        $query = "SELECT CBAAF.fid as fid,CBAA.fullname as fullname, CBAA.age as age, CBAA.gender as gender, CBAAF.schedule_date as followupdate, CBAAF.status as status, CBAAF.diagnosis as diagnosis, CBAU.fullname as doctor, CBAUP.paygrade as amount
                FROM clinic_business_account_appointment_follow_up  CBAAF 
                LEFT JOIN clinic_business_account_appointment CBAA ON CBAAF.aid = CBAA.aid 
                LEFT JOIN clinic_bussiness_account_users CBAU ON CBAAF.doctor_id = CBAU.user_id
                LEFT JOIN clinic_bussiness_account_users_paygrade CBAUP ON CBAU.user_id = CBAUP.user_id
                WHERE CBAA.aid = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $aid
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function myPatientAppointmentFollowupDashboard($client_id)
     {
        date_default_timezone_set('Asia/Manila');

        $query = "SELECT CBAAF.fid as fid,CBAA.fullname as fullname, CBAA.age as age, CBAA.gender as gender, CBAAF.schedule_date as followupdate, CBAAF.status as status, CBAAF.diagnosis as diagnosis, CBAU.fullname as doctor, CBAUP.paygrade as amount
        FROM clinic_business_account_appointment_follow_up  CBAAF 
        LEFT JOIN clinic_business_account_appointment CBAA ON CBAAF.aid = CBAA.aid 
        LEFT JOIN clinic_bussiness_account_users CBAU ON CBAAF.doctor_id = CBAU.user_id
        LEFT JOIN clinic_bussiness_account_users_paygrade CBAUP ON CBAU.user_id = CBAUP.user_id
        WHERE CBAA.uid = ? AND CBAAF.schedule_date = ?";
 
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $client_id
            ),
            array(
                "param_type" => "s",
                "param_value" => date('Y-m-d')
            )
        );

        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function myPatientAppointmentFollowupBussiness($account_id)
     {
        date_default_timezone_set('Asia/Manila');

        $query = "SELECT CBAAF.fid as fid,CBAA.fullname as fullname, CBAA.age as age, CBAA.gender as gender, CBAAF.schedule_date as followupdate, CBAAF.status as status, CBAAF.diagnosis as diagnosis, CBAU.fullname as doctor, CBAUP.paygrade as amount
        FROM clinic_business_account_appointment_follow_up  CBAAF 
        LEFT JOIN clinic_business_account_appointment CBAA ON CBAAF.aid = CBAA.aid 
        LEFT JOIN clinic_bussiness_account_users CBAU ON CBAAF.doctor_id = CBAU.user_id
        LEFT JOIN clinic_bussiness_account_users_paygrade CBAUP ON CBAU.user_id = CBAUP.user_id
        WHERE CBAA.account_id = ? AND CBAAF.schedule_date = ?";
 
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "s",
                "param_value" => date('Y-m-d')
            )
        );

        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function myPatientAppointmentFollowupBussinessOverall($account_id)
     {

        $query = "SELECT CBAAF.fid as fid,CBAA.fullname as fullname, CBAA.age as age, CBAA.gender as gender, CBAAF.schedule_date as followupdate, CBAAF.status as status, CBAAF.diagnosis as diagnosis, CBAU.fullname as doctor, CBAUP.paygrade as amount
        FROM clinic_business_account_appointment_follow_up  CBAAF 
        LEFT JOIN clinic_business_account_appointment CBAA ON CBAAF.aid = CBAA.aid 
        LEFT JOIN clinic_bussiness_account_users CBAU ON CBAAF.doctor_id = CBAU.user_id
        LEFT JOIN clinic_bussiness_account_users_paygrade CBAUP ON CBAU.user_id = CBAUP.user_id
        WHERE CBAA.account_id = ?";
 
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );

        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function validatedPatientExistence($email,$phone)
     {
        $query = "SELECT CBAP.client_id FROM clinic_business_account_patient CBAP WHERE CBAP.email = ? OR CBAP.phone = ?";
         
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $email
            ),
            array(
                "param_type" => "s",
                "param_value" => $phone
            )
        );

        $accountValidation = $this->getDBResult($query, $params);
        return $accountValidation;
     }

     function deletePatient($account_id,$client_id)
     {
        $query = "DELETE FROM clinic_business_account_patient WHERE client_id = ? AND account_id = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $client_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $this->updateDB($query, $params);
     }

     function updatePatientStatus($account_id,$client_id,$status)
     {
        $query = "UPDATE clinic_business_account_patient SET status = ? WHERE client_id = ? AND account_id = ?";
         
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $status
            ),
            array(
                "param_type" => "i",
                "param_value" => $client_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $this->updateDB($query, $params);
     }

     function updateFollowUpSchedule($account_id,$fid,$schedule_date)
     {
        $query = "UPDATE clinic_business_account_appointment_follow_up SET schedule_date = ? WHERE fid = ? AND account_id = ?";
         
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $schedule_date
            ),
            array(
                "param_type" => "i",
                "param_value" => $fid
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $this->updateDB($query, $params);
     }

     function updateFollowUpDiagnosis($account_id,$fid,$diagnosis)
     {
        $query = "UPDATE clinic_business_account_appointment_follow_up SET diagnosis = ? WHERE fid = ? AND account_id = ?";
         
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $diagnosis
            ),
            array(
                "param_type" => "i",
                "param_value" => $fid
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $this->updateDB($query, $params);
     }

     function updateFollowUpStatus($account_id,$fid,$status)
     {
        $query = "UPDATE clinic_business_account_appointment_follow_up SET status = ? WHERE fid = ? AND account_id = ?";
         
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $status
            ),
            array(
                "param_type" => "i",
                "param_value" => $fid
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $this->updateDB($query, $params);
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

     function myAppointmentBookingPayment($account_id, $aid, $client_id, $method, $trans_id, $url, $code, $email)
     {
        $query = "INSERT INTO clinic_business_my_appointment_payment  (account_id, aid, client_id, method, trans_id, url, code, email) VALUES (?,?,?,?,?,?,?,?)";
         
         $params = array(
             array(
                 "param_type" => "i",
                 "param_value" => $account_id
             ),
             array(
                 "param_type" => "i",
                 "param_value" => $aid
             ),
             array(
                 "param_type" => "i",
                 "param_value" => $client_id
             ),
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
                 "param_value" => $url
             ),
             array(
                 "param_type" => "s",
                 "param_value" => $code
             ),
             array(
                 "param_type" => "s",
                 "param_value" => $email
             )
         );
 
         $this->insertDB($query, $params);
     }

     function updateBookingStatusAfterPayment($aid)
     {
        $query = "UPDATE clinic_business_account_appointment SET status = 'PAYED PENDING' WHERE aid = ?";
         
         $params = array(
             array(
                 "param_type" => "i",
                 "param_value" => $aid
             )
         );
 
         $this->updateDB($query, $params);
     }

     function updateBookingStatusAfterPaymentCash($aid)
     {
        $query = "UPDATE clinic_business_account_appointment SET status = 'PAYED CONFIRM' WHERE aid = ?";
         
         $params = array(
             array(
                 "param_type" => "i",
                 "param_value" => $aid
             )
         );
 
         $this->updateDB($query, $params);
     }

     function myAppointmentBookingStatusUpdate($account_id, $client_id, $aid, $status)
     {
        $query = "UPDATE clinic_business_account_appointment SET status = ? WHERE aid = ? AND account_id = ?";
         
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $status
            ),
            array(
                "param_type" => "i",
                "param_value" => $aid
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );

        $this->updateDB($query, $params);
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

     function updateAccountIntegrationPayment($account_id,$pid,$public_key,$secret_key,$status,$mode)
     {
        $query = "UPDATE clinic_business_account_paymentintegration SET public_key = ?, secret_key = ?, status = ?, mode = ? WHERE pid = ? AND account_id = ?";
         
        $params = array(
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
            ),
            array(
                "param_type" => "i",
                "param_value" => $pid
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $this->updateDB($query, $params);
     }

     function updateAccountIntegrationPaymentStatus($account_id,$pid,$status)
     {
        $query = "UPDATE clinic_business_account_paymentintegration SET status = ? WHERE pid = ? AND account_id = ?";
         
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $status
            ),
            array(
                "param_type" => "i",
                "param_value" => $pid
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $this->updateDB($query, $params);
     }

     function deleteAccountIntegrationPayment($account_id,$pid)
     {
        $query = "DELETE FROM clinic_business_account_paymentintegration WHERE pid = ? AND account_id = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $pid
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $this->updateDB($query, $params);
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

     function acceptBookingAdmin($account_id, $pid, $client_id, $dob, $age, $fullname, $purpose, $purpose_description, $gender, $doa, $fromIns, $user_id)
     {
        $query = "CALL clinic_businessPatientBookingCreation(?,?,?,?,?,?,?,?,?,?,?,?)";
         
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
            ),
            array(
                "param_type" => "i",
                "param_value" => $user_id
            )
        );
        
        $account = $this->getDBResult($query, $params);
        return $account;
     }

     function acceptBooking($account_id, $pid, $client_id, $dob, $age, $fullname, $purpose, $purpose_description, $gender, $doa, $fromIns)
     {
        $query = "CALL clinic_businessPatientBookingCreationNormal(?,?,?,?,?,?,?,?,?,?,?)";
         
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

     function updateMyPatientAppointment($account_id,$aid,$schedule_date)
     {
        $query = "UPDATE clinic_business_account_appointment SET schedule_date = ? WHERE account_id = ? AND aid = ?";
         
         $params = array(
             array(
                 "param_type" => "s",
                 "param_value" => $schedule_date
             ),
             array(
                 "param_type" => "i",
                 "param_value" => $account_id
             ),
             array(
                 "param_type" => "i",
                 "param_value" => $aid
             )
         );
         
         $this->updateDB($query, $params);
     }

     function updateMyPatientInformation($account_id,$aid,$fullname,$purpose,$purpose_description,$gender)
     {
        $query = "UPDATE clinic_business_account_appointment SET fullname = ?, purpose = ?, purpose_description = ?, gender = ?  WHERE account_id = ? AND aid = ?";
         
        $params = array(
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
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $aid
            )
        );
        
        $this->updateDB($query, $params);
     }

     function deleteMyPatientInformationAppointment($account_id,$aid)
     {
        $query = "DELETE FROM clinic_business_account_appointment WHERE account_id = ? AND aid = ?";
         
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $aid
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

    function checkTheme($accountId)
    {
        $query = "SELECT * FROM clinic_account_theme_header WHERE account_id = ?";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $accountId
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }

    function checkSideBarTheme($accountId)
    {
        $query = "SELECT * FROM clinic_account_theme_sidebar WHERE account_id = ?";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $accountId
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }

    function account_activity_insert($accountId, $page, $account_activity)
    {
        $query = "INSERT INTO clinic_account_owner_history (account_id, page, account_activity) VALUES (?,?,?)";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $accountId
            ),
            array(
                "param_type" => "s",
                "param_value" => $page
            ),
            array(
                "param_type" => "s",
                "param_value" => $account_activity
            )
        );
        
        $this->insertDB($query, $params);
    }

    function account_activity_insertPatient($account_id, $client_id, $view, $account_activity)
    {
        $query = "INSERT INTO clinic_account_patient_history (account_id, client_id, page, account_activity) VALUES (?,?,?,?)";
        
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
                "param_type" => "s",
                "param_value" => $view
            ),
            array(
                "param_type" => "s",
                "param_value" => $account_activity
            )
        );
        
        $this->insertDB($query, $params);
    }

    function account_activity_insertStaff($account_id, $user_id, $view, $account_activity)
    {
        $query = "INSERT INTO clinic_account_staff_history (account_id, user_id, page, account_activity) VALUES (?,?,?,?)";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $user_id
            ),
            array(
                "param_type" => "s",
                "param_value" => $view
            ),
            array(
                "param_type" => "s",
                "param_value" => $account_activity
            )
        );
        
        $this->insertDB($query, $params);
    }


    function myAccountOwnerActivity($account_id)
    {
        $query = "SELECT * FROM clinic_account_owner_history WHERE account_id = ?";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }

    function myAccountPatientActivity($client_id)
    {
        $query = "SELECT * FROM clinic_account_patient_history WHERE client_id = ?";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $client_id
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }

    function myAccountStaffActivity($user_id)
    {
        $query = "SELECT * FROM clinic_account_staff_history WHERE user_id = ?";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $user_id
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }


    function profitChartToday($account_id)
    {
        date_default_timezone_set('Asia/Manila');
        $query = "SELECT SUM(paygrade) as total FROM clinic_business_my_appointment_payment CBMAP LEFT JOIN clinic_business_assigned_doctor_appointment CBADA ON CBMAP.aid = CBADA.aid LEFT JOIN clinic_bussiness_account_users_paygrade CBAUP ON CBADA.user_id = CBAUP.user_id WHERE CBMAP.account_id = ? AND CBMAP.date_created = ?";
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "s",
                "param_value" => date('Y-m-d')
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }

    function appointmentChartToday($account_id)
    {
        date_default_timezone_set('Asia/Manila');
        $query = "SELECT count(*) as count FROM clinic_business_account_appointment WHERE date_created = ? AND account_id = ?";
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
        $query = "SELECT count(*) as count FROM clinic_business_account_inquiry WHERE date_created = ? AND account_id = ?";
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
        $query = "SELECT count(*) as count FROM clinic_bussiness_account_users WHERE date_created = ? AND account_id = ?";
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


    function profitChartOverall($account_id)
    {
        date_default_timezone_set('Asia/Manila');
        $query = "SELECT SUM(paygrade) as total FROM clinic_business_my_appointment_payment CBMAP LEFT JOIN clinic_business_assigned_doctor_appointment CBADA ON CBMAP.aid = CBADA.aid LEFT JOIN clinic_bussiness_account_users_paygrade CBAUP ON CBADA.user_id = CBAUP.user_id WHERE CBMAP.account_id = ?";
        $params = array(
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
        $query = "SELECT count(*) as count FROM clinic_business_account_appointment WHERE account_id = ?";
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }

    function appointmentChartBarOverall($account_id)
    {
        date_default_timezone_set('Asia/Manila');
        $query = "SELECT count(*) as count FROM clinic_business_account_inquiry WHERE account_id = ?";
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
        $query = "SELECT count(*) as count FROM clinic_bussiness_account_users WHERE account_id = ?";
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }

    function myBusinessSupportTicket($account_id, $level, $subject, $concern)
    {
        $query = "INSERT INTO clinic_business_service_ticket (account_id, level, subject, concern) VALUES (?,?,?,?)";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            ),
            array(
                "param_type" => "i",
                "param_value" => $level
            ),
            array(
                "param_type" => "s",
                "param_value" => $subject
            ),
            array(
                "param_type" => "s",
                "param_value" => $concern
            )
        );
        
        $this->insertDB($query, $params);
    }

    function myBusinessSupportTicketView($account_id)
    {
        $query = "SELECT CBST.* FROM clinic_business_service_ticket CBST WHERE CBST.account_id = ?";
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }

    function myBusinessSupportTicketViewAll()
    {
        $query = "SELECT CBST.* FROM clinic_business_service_ticket CBST";
        
        $result = $this->getDBResult($query);
        return $result;
    }

    function updatemyBusinessSupportTicketAdmin($ticketid, $level, $status)
    {
        $query = "UPDATE clinic_business_service_ticket SET level = ?, status = ? WHERE ticketid = ?";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $level
            ),
            array(
                "param_type" => "s",
                "param_value" => $status
            ),
            array(
                "param_type" => "i",
                "param_value" => $ticketid
            )
        );
        
        $this->updateDB($query, $params);
    }

    function updatemyBusinessSupportTicket($account_id, $level, $ticketid, $subject, $concern)
    {
        $query = "UPDATE clinic_business_service_ticket SET level = ?, subject = ?, concern = ? WHERE ticketid = ? AND account_id = ?";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $level
            ),
            array(
                "param_type" => "s",
                "param_value" => $subject
            ),
            array(
                "param_type" => "s",
                "param_value" => $concern
            ),
            array(
                "param_type" => "i",
                "param_value" => $ticketid
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $this->updateDB($query, $params);
    }

    function createmyBusinessSupportTicketResponse($ticketid, $response)
    {
        $query = "INSERT INTO clinic_business_service_ticket_response (ticket_id,response) VALUES (?,?)";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $ticketid
            ),
            array(
                "param_type" => "s",
                "param_value" => $response
            )
        );
        
        $this->insertDB($query, $params);
    }

    function viewTicketResponse($ticketid)
    {
        $query = "SELECT CBSTR.* FROM clinic_business_service_ticket_response CBSTR WHERE CBSTR.ticket_id = ?";
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $ticketid
            )
        );
        
        $result = $this->getDBResult($query, $params);
        return $result;
    }

    function deletemyBusinessSupportTicket($account_id, $ticketid)
    {
        $query = "DELETE FROM clinic_business_service_ticket WHERE ticketid = ? AND account_id = ?";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $ticketid
            ),
            array(
                "param_type" => "i",
                "param_value" => $account_id
            )
        );
        
        $this->updateDB($query, $params);
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
        $query = "SELECT SUM(CAT.amount) as total FROM clinic_business_account_subscription CBAS LEFT JOIN clinic_account_type CAT ON CBAS.account_type = CAT.account_type";
        $result = $this->getDBResult($query);
        return $result;
    }



}

$portCont = new userController();

?>