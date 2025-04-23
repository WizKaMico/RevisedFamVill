-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 23, 2025 at 05:25 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `clinic_system`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_businessAccountRecovery` (IN `email` VARCHAR(50), IN `code` INT(50))   BEGIN 
DECLARE isAccountExist INT DEFAULT 0; 
SELECT COUNT(*) INTO isAccountExist FROM clinic_business_account CBA WHERE CBA.email = email; 
IF isAccountExist > 0 THEN
UPDATE clinic_business_account CBA SET CBA.code = code WHERE CBA.email = email;
SELECT CBA.* FROM clinic_business_account CBA WHERE CBA.email = email;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_businessPatientBookingCreation` (IN `account_id` INT(11), IN `pid` VARCHAR(50), IN `client_id` INT(10), IN `dob` DATE, IN `age` INT(10), IN `fullname` VARCHAR(100), IN `purpose` VARCHAR(100), IN `purpose_description` TEXT, IN `gender` VARCHAR(50), IN `doa` DATE, IN `fromIns` VARCHAR(50), IN `user_id` INT(11))   BEGIN
INSERT INTO clinic_business_account_appointment (account_id,pid,uid,date_birth,age,fullname,purpose,purpose_description,gender,schedule_date,status,fromIns) VALUES (account_id,pid,client_id,dob,age,fullname,purpose,purpose_description,gender,doa,'CONFIRMED',fromIns);
  -- Get the last inserted ID
    SET @last_aid = LAST_INSERT_ID();

    -- Assign a doctor
    INSERT INTO clinic_business_assigned_doctor_appointment (
        account_id, aid, user_id
    ) VALUES (
        account_id, @last_aid, user_id
    );

    -- Return the inserted appointment
    SELECT CBAA.*, CBAP.email FROM clinic_business_account_appointment CBAA
    LEFT JOIN clinic_business_account_patient CBAP ON CBAA.uid = CBAP.client_id
    WHERE CBAA.aid = @last_aid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_businessPatientBookingCreationNormal` (IN `account_id` INT(11), IN `pid` VARCHAR(50), IN `client_id` INT(10), IN `dob` DATE, IN `age` INT(10), IN `fullname` VARCHAR(100), IN `purpose` VARCHAR(100), IN `purpose_description` TEXT, IN `gender` VARCHAR(50), IN `doa` DATE, IN `fromIns` VARCHAR(50))   BEGIN
INSERT INTO clinic_business_account_appointment (account_id,pid,uid,date_birth,age,fullname,purpose,purpose_description,gender,schedule_date,status,fromIns) VALUES (account_id,pid,client_id,dob,age,fullname,purpose,purpose_description,gender,doa,'BOOKED',fromIns);
  -- Get the last inserted ID
    SET @last_aid = LAST_INSERT_ID();

    -- Return the inserted appointment
     SELECT CBAA.*, CBAP.email FROM clinic_business_account_appointment CBAA
    LEFT JOIN clinic_business_account_patient CBAP ON CBAA.uid = CBAP.client_id
    WHERE CBAA.aid = @last_aid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_businessPatientBookingView` (IN `uid` INT(10))   BEGIN
SELECT CBAA.*,CBS.service,CBADA.diagnosis as diagnosis,CBAUP.paygrade as paygrade,CBAU.fullname as doctor FROM clinic_business_account_appointment CBAA LEFT JOIN clinic_business_service CBS ON CBAA.purpose = CBS.bsid LEFT JOIN clinic_business_assigned_doctor_appointment CBADA ON CBAA.aid = CBADA.aid LEFT JOIN clinic_bussiness_account_users_paygrade CBAUP ON CBADA.user_id = CBAUP.user_id
LEFT JOIN clinic_bussiness_account_users CBAU ON CBADA.user_id = CBAU.user_id
WHERE CBAA.uid = uid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_businessPatientBookingViewUpcoming` (IN `uid` INT(10), IN `dateToday` DATE)   BEGIN
SELECT CBAA.*,CBS.service,CBADA.diagnosis as diagnosis,CBAUP.paygrade as amount,CBAU.fullname as doctor,CBAP.email as email, CBAA.date_birth as dob FROM clinic_business_account_appointment CBAA LEFT JOIN clinic_business_service CBS ON CBAA.purpose = CBS.bsid LEFT JOIN clinic_business_assigned_doctor_appointment CBADA ON CBAA.aid = CBADA.aid LEFT JOIN clinic_bussiness_account_users_paygrade CBAUP ON CBADA.user_id = CBAUP.user_id LEFT JOIN clinic_bussiness_account_users CBAU ON CBADA.user_id = CBAU.user_id LEFT JOIN clinic_business_account_patient CBAP ON CBAA.uid = CBAP.client_id WHERE CBAA.uid = uid AND CBAA.schedule_date = dateToday;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_accountLogin` (IN `session_id` INT(11))   BEGIN
DECLARE isAccountExist INT DEFAULT 0;
SELECT COUNT(*) INTO isAccountExist FROM clinic_business_account CBA WHERE CBA.account_id = session_id;
IF isAccountExist > 0 THEN
SELECT CBA.* FROM clinic_business_account CBA WHERE CBA.account_id = session_id;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_accountTypes` ()   BEGIN
SELECT CAT.* FROM clinic_account_type CAT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_account_accountLoginValidation` (IN `username` VARCHAR(50), IN `password` VARCHAR(255))   BEGIN
    DECLARE isAccountExist INT DEFAULT 0;

    -- Check if the account exists and is verified
    SELECT COUNT(*) INTO isAccountExist 
    FROM clinic_business_account_patient CBAP 
    WHERE CBAP.username = username 
    AND CBAP.password = password 
    AND CBAP.status = 'VERIFIED';

    -- If account exists, return user details
    IF isAccountExist > 0 THEN
        SELECT * FROM clinic_business_account_patient CBAP 
        WHERE CBAP.username = username 
        AND CBAP.password = password 
        AND CBAP.status = 'VERIFIED';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_account_inquiryCreation` (IN `account_id` INT(11), IN `name` VARCHAR(50), IN `email` VARCHAR(50), IN `subject` VARCHAR(50), IN `message` TEXT)   BEGIN
INSERT INTO clinic_business_account_inquiry (account_id, name, email, subject, message) VALUES (account_id, name, email, subject, message);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_account_integrationSpecific` (IN `account_id` INT(11))   BEGIN
SELECT CBAP.* FROM clinic_business_account_paymentintegration CBAP WHERE CBAP.account_id = account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_account_productUpload` (IN `account_id` INT(11), IN `name` VARCHAR(255), IN `code` VARCHAR(255), IN `target_file` TEXT, IN `price` DOUBLE(10,2), IN `quantity` INT(50), IN `status` VARCHAR(50))   BEGIN
INSERT INTO clinic_account_product (account_id,name,code,image,price,quantity,status) VALUES (account_id,name,code,target_file,price,quantity,status); 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_account_product_view` (IN `account_id` INT(11))   BEGIN
SELECT CAP.* FROM clinic_account_product CAP WHERE CAP.account_id = account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_account_roles` (IN `account_id` INT(11))   BEGIN 
SELECT CBR.* FROM clinic_business_roles CBR WHERE CBR.account_id = account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_account_services` (IN `account_id` INT(11), IN `service` VARCHAR(50))   BEGIN 
INSERT INTO clinic_business_service (account_id,service) VALUES (account_id,service);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_account_services_view` (IN `account_id` INT(11))   BEGIN
SELECT CBS.* FROM clinic_business_service CBS WHERE CBS.account_id = account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_account_staffLoginValidation` (IN `email` VARCHAR(50), IN `password` VARCHAR(255))   BEGIN
    DECLARE isAccountExist INT DEFAULT 0;

    -- Check if the account exists and is verified
    SELECT COUNT(*) INTO isAccountExist 
    FROM clinic_bussiness_account_users CBAU
    WHERE CBAU.email = email 
    AND CBAU.password = password 
    AND CBAU.status = 'VERIFIED';

    -- If account exists, return user details
    IF isAccountExist > 0 THEN
        SELECT CBAU.*,CBA.business_name,CBR.role_name FROM clinic_bussiness_account_users CBAU LEFT JOIN clinic_business_account CBA ON CBAU.account_id = CBA.account_id LEFT JOIN clinic_business_roles CBR ON CBAU.role = CBR.role_id WHERE CBAU.email = email  AND CBAU.password = password AND CBAU.status = 'VERIFIED';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_account_userCreation` (IN `account_id` INT(11), IN `fullname` VARCHAR(50), IN `input_email` VARCHAR(50), IN `input_phone` VARCHAR(50), IN `password` VARCHAR(255), IN `unhashed` VARCHAR(50), IN `role` INT(11))   BEGIN
    DECLARE isAccountExist INT DEFAULT 0;

    -- Check if the email OR phone already exists
    SELECT COUNT(*) INTO isAccountExist 
    FROM clinic_bussiness_account_users 
    WHERE email = input_email OR phone = input_phone;

    -- If neither email nor phone exists, insert the new record
    IF isAccountExist = 0 THEN
        INSERT INTO clinic_bussiness_account_users (account_id, fullname, email, phone, password, unhashed, role) 
        VALUES (account_id, fullname, input_email, input_phone, password, unhashed, role);
    ELSE
        -- Return existing user data if the email or phone already exists
        SELECT * FROM clinic_bussiness_account_users 
        WHERE email = input_email OR phone = input_phone;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_account_view` (IN `business_name` VARCHAR(50))   BEGIN
SELECT CBA.* FROM clinic_business_account CBA WHERE CBA.business_name = business_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_createAccountDocuments_final` (IN `email` VARCHAR(50), IN `business_ownership` VARCHAR(50), IN `business_cert` VARCHAR(255), IN `business_tin` VARCHAR(255))   BEGIN
DECLARE isAccountExist INT DEFAULT 0;
SELECT COUNT(*) INTO isAccountExist FROM clinic_business_account WHERE email = email;
IF isAccountExist > 0 THEN
UPDATE clinic_business_account CBA SET CBA.business_ownership = business_ownership, CBA.business_cert = business_cert, CBA.business_tin = business_tin, CBA.status = 'VERIFIED' WHERE CBA.email = email;
SELECT CBA.* FROM clinic_business_account CBA WHERE CBA.email = email;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_createAccountPassword_preliminary` (IN `emailx` VARCHAR(50), IN `codex` INT(50), IN `hashedx` VARCHAR(255), IN `passwordx` VARCHAR(50))   BEGIN
  DECLARE isAccountExist INT DEFAULT 0; 
    DECLARE accountStatus VARCHAR(50);

    -- Check if account exists
    SELECT COUNT(*) INTO isAccountExist 
    FROM clinic_business_account CBA
    WHERE CBA.email = emailx AND CBA.code = codex;

    IF isAccountExist > 0 THEN
        -- Fetch account status
        SELECT CBA.status INTO accountStatus 
        FROM clinic_business_account CBA
        WHERE CBA.email = emailx AND CBA.code = codex;

        -- If already subscribed, update only the password
        IF accountStatus = 'SUBSCRIBED' THEN
            UPDATE clinic_business_account CBA
            SET CBA.password = hashed, 
                CBA.unhashed = password 
            WHERE CBA.email = xemail AND CBA.code = codex;
        ELSE
            -- Otherwise, update password and mark as confirmed
            UPDATE clinic_business_account CBA
            SET CBA.password = hashedx, 
                CBA.unhashed = passwordx, 
                CBA.status = 'CONFIRMED' 
            WHERE CBA.email = emailx AND CBA.code = codex;
        END IF;

        -- Return updated account details
        SELECT CBA.* FROM clinic_business_account CBA
        WHERE CBA.email = email AND CBA.code = code;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_createAccount_preliminary` (IN `business` VARCHAR(50), IN `email` VARCHAR(50), IN `phone` VARCHAR(50), IN `region` VARCHAR(150), IN `province` VARCHAR(150), IN `city` VARCHAR(150), IN `barangay` VARCHAR(150), IN `street` VARCHAR(150), IN `code` INT(50))   BEGIN
 INSERT INTO clinic_business_account (business_name,email,phone,region,province,city,barangay,street,code) VALUES (business,email,phone,region,province,city,barangay,street,code);
  SELECT CBA.* FROM clinic_business_account CBA WHERE CBA.email = email AND CBA.phone = phone;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_faq_view` ()   BEGIN
SELECT CMF.* FROM clinic_main_faq CMF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_inquiry` (IN `fullname` VARCHAR(50), IN `email` VARCHAR(50), IN `subject` VARCHAR(50), IN `message` TEXT)   BEGIN
INSERT INTO clinic_main_inquiry (fullname,email,subject,message) VALUES (fullname,email,subject,message);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_login` (IN `emailx` VARCHAR(50), IN `passwordx` VARCHAR(255))   BEGIN 
DECLARE isAccountExist INT DEFAULT 0;
SELECT COUNT(*) INTO isAccountExist FROM clinic_business_account CBA WHERE CBA.email = emailx AND CBA.password = passwordx;
IF isAccountExist > 0 THEN
SELECT CBA.* FROM clinic_business_account CBA WHERE CBA.email = emailx AND CBA.password = passwordx;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_myAccountBilling` (IN `account_id` INT(11))   BEGIN
SELECT CBAS.*,CAT.account,CAT.amount FROM clinic_business_account_subscription CBAS LEFT JOIN clinic_account_type CAT ON CBAS.account_type = CAT.account_type WHERE CBAS.account_id = account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_myAccountBillingIntegration` (IN `account_id` INT(11), IN `public_key` VARCHAR(255), IN `secret_key` VARCHAR(255), IN `status` VARCHAR(50), IN `mode` VARCHAR(50))   BEGIN
INSERT INTO clinic_business_account_paymentintegration (account_id,public_key,secret_key,status,mode) VALUES (account_id,public_key,secret_key,status,mode);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_myAccountUsers` (IN `account_id` INT(11))   BEGIN
SELECT CBAU.*,CBR.*,CBAUP.paygrade FROM clinic_bussiness_account_users CBAU LEFT JOIN clinic_business_roles CBR ON CBAU.role = CBR.role_id
LEFT JOIN clinic_bussiness_account_users_paygrade CBAUP ON CBAU.user_id = CBAUP.user_id
WHERE CBAU.account_id = account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_patient_accountForgotPasswordVerification` (IN `email` VARCHAR(50), IN `code` INT(50))   BEGIN
    DECLARE isAccount INT DEFAULT 0;

    -- Check if the account exists
    SELECT COUNT(*) INTO isAccount 
    FROM clinic_business_account_patient CBAP 
    WHERE CBAP.email = email; 

    IF isAccount > 0 THEN
       UPDATE clinic_business_account_patient SET code = code;
        SELECT CBAP.* FROM clinic_business_account_patient CBAP WHERE CBAP.email = email;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_patient_accountNewPasswordUpdate` (IN `password` VARCHAR(255), IN `unhashed` VARCHAR(50), IN `email` VARCHAR(50), IN `code` INT(50))   BEGIN
    DECLARE isAccountExisting INT DEFAULT 0;

    -- Check if the email exists in fam_user
    SELECT COUNT(*) INTO isAccountExisting 
    FROM clinic_business_account_patient CBAP 
    WHERE CBAP.email = email AND CBAP.code = code; 

    -- If both exist, proceed with the update
    IF isAccountExisting > 0 THEN
        -- Update password in fam_user
        UPDATE clinic_business_account_patient 
        SET password = password, unhashed = unhashed 
        WHERE email = email AND code = code;
        
        -- Return updated user details
        SELECT * FROM clinic_business_account_patient CBAP WHERE CBAP.email = email AND CBAP.code = code;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_patient_accountVerification` (IN `email` VARCHAR(50), IN `code` INT(50))   BEGIN
    DECLARE famville_verifyAccountCode INT DEFAULT 0;

    -- Check if the email and code exist
    SELECT COUNT(*) INTO famville_verifyAccountCode 
    FROM clinic_business_account_patient CBAP
    WHERE CBAP.email = email AND CBAP.code = code;

    IF famville_verifyAccountCode > 0 THEN
        -- Update status to VERIFIED
        UPDATE clinic_business_account_patient 
        SET status = 'VERIFIED' 
        WHERE email = email AND code = code;

        -- Return the updated patient account
        SELECT * FROM clinic_business_account_patient CBAP 
        WHERE CBAP.email = email AND CBAP.code = code;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_role` (IN `account_id` INT(11), IN `role_name` VARCHAR(50))   BEGIN
INSERT INTO clinic_business_roles (account_id,role_name) VALUES (account_id,role_name);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_subscription` (IN `method` VARCHAR(50), IN `trans_id` VARCHAR(50), IN `email` VARCHAR(50), IN `code` VARCHAR(50), IN `account_type` INT)   BEGIN
    DECLARE accountId INT DEFAULT 0;

    -- Retrieve the account ID associated with the given email
    SELECT account_id INTO accountId FROM clinic_business_account CBA WHERE CBA.email = email;

    -- Ensure a valid account ID exists before inserting
    IF accountId > 0 THEN 
        INSERT INTO clinic_business_account_subscription 
            (account_id, paymethod, trans_id, email, code, account_type) 
        VALUES 
            (accountId, method, trans_id, email, code, account_type);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_subscriptionPaymentValidation` (IN `p_code` VARCHAR(50), IN `p_status` VARCHAR(50), IN `p_email` VARCHAR(50))   BEGIN
    DECLARE isAccountPay INT DEFAULT 0;

    -- Check if subscription exists for the given code
    SELECT COUNT(*) INTO isAccountPay 
    FROM clinic_business_account_subscription 
    WHERE code = p_code;

    -- If subscription exists, update its status
    IF isAccountPay > 0 THEN
        IF p_status = 'PAYED' THEN
            -- Update subscription status
            UPDATE clinic_business_account_subscription 
            SET status = p_status 
            WHERE code = p_code;
            
            -- Update account status to 'SUBSCRIBED'
            UPDATE clinic_business_account 
            SET status = 'SUBSCRIBED' 
            WHERE email = p_email;
        ELSE
            -- Just update subscription status
            UPDATE clinic_business_account_subscription 
            SET status = p_status 
            WHERE code = p_code;
        END IF;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_patient_AccountCreation` (IN `account_id` INT(11), IN `fullname` VARCHAR(50), IN `username` VARCHAR(50), IN `email` VARCHAR(50), IN `phone` VARCHAR(50), IN `password` VARCHAR(255), IN `unhashed` VARCHAR(50), IN `code` INT(50))   BEGIN
DECLARE isAccountExist INT DEFAULT 0;
SELECT COUNT(*) INTO isAccountExist FROM clinic_business_account_patient CBAP WHERE CBAP.email = email OR CBAP.phone = phone; 
IF isAccountExist = 0 THEN
INSERT INTO clinic_business_account_patient (account_id, fullname, username, email, phone, password, unhashed, code) VALUES (account_id, fullname, username, email, phone, password, unhashed, code);
SELECT CBAP.* FROM clinic_business_account_patient CBAP WHERE CBAP.email = email AND CBAP.phone = phone; 
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_patient_accountLogin` (IN `client_id` INT(11))   BEGIN
DECLARE isAccountExist INT DEFAULT 0;
SELECT COUNT(*) INTO isAccountExist FROM clinic_business_account_patient CBAP WHERE CBAP.client_id = client_id;
IF isAccountExist > 0 THEN
SELECT CBAP.*,CBA.business_name FROM clinic_business_account_patient CBAP LEFT JOIN clinic_business_account CBA ON CBAP.account_id = CBA.account_id WHERE CBAP.client_id = client_id;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_paymongoAccount` ()   BEGIN 
SELECT CBMPC.* FROM clinic_business_main_paymongo_configuration CBMPC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_staff_accountLogin` (IN `user_id` INT(11))   BEGIN
DECLARE isAccountExist INT DEFAULT 0;
SELECT COUNT(*) INTO isAccountExist FROM clinic_bussiness_account_users CBAU WHERE CBAU.user_id = user_id;
IF isAccountExist > 0 THEN
SELECT CBAU.*,CBA.business_name,CBR.role_name,CBSA.sid FROM clinic_bussiness_account_users CBAU 
LEFT JOIN clinic_business_account CBA ON CBAU.account_id = CBA.account_id 
LEFT JOIN clinic_business_roles CBR ON CBAU.role = CBR.role_id 
LEFT JOIN clinic_business_service_account CBSA ON CBR.role_id = CBSA.role_id
WHERE CBAU.user_id = user_id;
END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `clinic_account_cart`
--

CREATE TABLE `clinic_account_cart` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `member_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `clinic_account_cart`
--

INSERT INTO `clinic_account_cart` (`id`, `account_id`, `client_id`, `product_id`, `quantity`, `member_id`) VALUES
(5, 1, 1, 2, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `clinic_account_order`
--

CREATE TABLE `clinic_account_order` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `amount` double NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  `zip` varchar(255) NOT NULL,
  `country` varchar(255) NOT NULL,
  `payment_type` varchar(255) NOT NULL,
  `order_status` varchar(255) NOT NULL,
  `order_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinic_account_order_item`
--

CREATE TABLE `clinic_account_order_item` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `item_price` double NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinic_account_owner_history`
--

CREATE TABLE `clinic_account_owner_history` (
  `actid` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `page` varchar(255) NOT NULL,
  `account_activity` varchar(255) NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_account_owner_history`
--

INSERT INTO `clinic_account_owner_history` (`actid`, `account_id`, `page`, `account_activity`, `date_created`) VALUES
(1, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-27'),
(2, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-27'),
(3, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-27'),
(4, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-27'),
(5, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-27'),
(6, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-27'),
(7, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-27'),
(8, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-27'),
(9, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-27'),
(10, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-27'),
(11, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-27'),
(12, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(13, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(14, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(15, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(16, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(17, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(18, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(19, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(20, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(21, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(22, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(23, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(24, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(25, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(26, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(27, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(28, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(29, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(30, 1, 'INTEGRATION', 'Created New Integration to INTEGRATION', '2025-03-27'),
(31, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(32, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(33, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(34, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(35, 1, 'INTEGRATION', 'Updated Integration to INTEGRATION', '2025-03-27'),
(36, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(37, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(38, 1, 'INTEGRATION', 'Updated Integration to INTEGRATION', '2025-03-27'),
(39, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(40, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(41, 1, 'INTEGRATION', 'Updated Integration to INTEGRATION', '2025-03-27'),
(42, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(43, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(44, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(45, 1, 'INTEGRATION', 'Updated Integration to INTEGRATION', '2025-03-27'),
(46, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(47, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(48, 1, 'INTEGRATION', 'Updated Status Integration on INTEGRATION', '2025-03-27'),
(49, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(50, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(51, 1, 'INTEGRATION', 'Updated Integration to INTEGRATION', '2025-03-27'),
(52, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(53, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(54, 1, 'INTEGRATION', 'Updated Integration to INTEGRATION', '2025-03-27'),
(55, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(56, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(57, 1, 'INTEGRATION', 'Updated Integration to INTEGRATION', '2025-03-27'),
(58, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(59, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(60, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(61, 1, 'INTEGRATION', 'Deleted Integration on INTEGRATION', '2025-03-27'),
(62, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(63, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(64, 1, 'BILLING', 'Navigate to BILLING', '2025-03-27'),
(65, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(66, 1, 'BILLING', 'Navigate to BILLING', '2025-03-27'),
(67, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(68, 1, 'BILLING', 'Navigate to BILLING', '2025-03-27'),
(69, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-27'),
(70, 1, 'BILLING', 'Navigate to BILLING', '2025-03-27'),
(71, 1, 'BILLING', 'Navigate to BILLING', '2025-03-27'),
(72, 1, 'BILLING', 'Navigate to BILLING', '2025-03-27'),
(73, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-27'),
(74, 1, 'BILLING', 'Navigate to BILLING', '2025-03-27'),
(75, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(76, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(77, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(78, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(79, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(80, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(81, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(82, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(83, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(84, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(85, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(86, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(87, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(88, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(89, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(90, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(91, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(92, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(93, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(94, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(95, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(96, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(97, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(98, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(99, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(100, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(101, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(102, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(103, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(104, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(105, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(106, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(107, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-28'),
(108, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(109, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(110, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(111, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(112, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(113, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(114, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(115, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(116, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(117, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(118, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(119, 1, 'ACCOUNTS', 'Update Accounts to ACCOUNTS', '2025-03-28'),
(120, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(121, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(122, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(123, 1, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-03-28'),
(124, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(125, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(126, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(127, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(128, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(129, 1, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-03-28'),
(130, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(131, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(132, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(133, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(134, 1, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-03-28'),
(135, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(136, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(137, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(138, 1, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-03-28'),
(139, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(140, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(141, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(142, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(143, 1, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-03-28'),
(144, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(145, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(146, 1, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-03-28'),
(147, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(148, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(149, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(150, 1, 'ACCOUNTS', 'Created New Account to ACCOUNTS', '2025-03-28'),
(151, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(152, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(153, 1, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-03-28'),
(154, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(155, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(156, 1, 'ACCOUNTS', 'Delete Accounts to ACCOUNTS', '2025-03-28'),
(157, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(158, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(159, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(160, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(161, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(162, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(163, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(164, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(165, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(166, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(167, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(168, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(169, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(170, 1, 'ACCOUNTS', 'Added Paygrade Accounts to ACCOUNTS', '2025-03-28'),
(171, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(172, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(173, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(174, 1, 'ACCOUNTS', 'Added Paygrade Accounts to ACCOUNTS', '2025-03-28'),
(175, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(176, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(177, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(178, 1, 'ACCOUNTS', 'Added Paygrade Accounts to ACCOUNTS', '2025-03-28'),
(179, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(180, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(181, 1, 'ACCOUNTS', 'Added Paygrade Accounts to ACCOUNTS', '2025-03-28'),
(182, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(183, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(184, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(185, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(186, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(187, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-28'),
(188, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(189, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(190, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(191, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(192, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(193, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(194, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(195, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(196, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(197, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(198, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(199, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(200, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(201, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(202, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(203, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(204, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(205, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(206, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(207, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(208, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(209, 1, 'SERVICE', 'Deleted Integration on SERVICE', '2025-03-28'),
(210, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(211, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(212, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(213, 1, 'SERVICE', 'Deleted Service on SERVICE', '2025-03-28'),
(214, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(215, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(216, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(217, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(218, 1, 'SERVICE', 'Updated Service on SERVICE', '2025-03-28'),
(219, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(220, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(221, 1, 'SERVICE', 'Deleted Service on SERVICE', '2025-03-28'),
(222, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(223, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(224, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(225, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(226, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(227, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(228, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(229, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(230, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(231, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(232, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(233, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(234, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(235, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(236, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(237, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(238, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(239, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(240, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-28'),
(241, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(242, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(243, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(244, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(245, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(246, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(247, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(248, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(249, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(250, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(251, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(252, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(253, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(254, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(255, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(256, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(257, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(258, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(259, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(260, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(261, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(262, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(263, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(264, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(265, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(266, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(267, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(268, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(269, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(270, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(271, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(272, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(273, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(274, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(275, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(276, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(277, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(278, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(279, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(280, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(281, 1, 'PATIENT', 'Updated Patient on PATIENT', '2025-03-28'),
(282, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(283, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(284, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(285, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(286, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(287, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(288, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(289, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(290, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(291, 1, 'PATIENT', 'Updated Status Integration on PATIENT', '2025-03-28'),
(292, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(293, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(294, 1, 'INTEGRATION', 'Updated Status Integration on INTEGRATION', '2025-03-28'),
(295, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(296, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(297, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(298, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(299, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(300, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(301, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(302, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(303, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(304, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(305, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(306, 1, 'INTEGRATION', 'Updated Status Integration on INTEGRATION', '2025-03-28'),
(307, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(308, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(309, 1, 'INTEGRATION', 'Updated Status Integration on INTEGRATION', '2025-03-28'),
(310, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(311, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(312, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(313, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(314, 1, 'PATIENT', 'Updated Status Integration on PATIENT', '2025-03-28'),
(315, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(316, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(317, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(318, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(319, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(320, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(321, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(322, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(323, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(324, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(325, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(326, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(327, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(328, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(329, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(330, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(331, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(332, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(333, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(334, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(335, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(336, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(337, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(338, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(339, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(340, 1, 'PATIENT', 'Create Patient on PATIENT', '2025-03-28'),
(341, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(342, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(343, 1, 'PATIENT', 'Updated Patient on PATIENT', '2025-03-28'),
(344, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(345, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(346, 1, 'PATIENT', 'Updated Status Integration on PATIENT', '2025-03-28'),
(347, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(348, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(349, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(350, 1, 'PATIENT', 'Delete Patient on PATIENT', '2025-03-28'),
(351, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(352, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(353, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(354, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(355, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(356, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(357, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(358, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(359, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(360, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(361, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(362, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(363, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(364, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(365, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(366, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(367, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(368, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(369, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(370, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(371, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(372, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(373, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(374, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(375, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(376, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(377, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(378, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(379, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(380, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(381, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(382, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(383, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(384, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(385, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(386, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(387, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(388, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(389, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(390, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(391, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(392, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(393, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(394, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(395, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(396, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(397, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(398, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(399, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(400, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(401, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(402, 1, 'ACCOUNTS', 'Created Service Role to ACCOUNTS', '2025-03-28'),
(403, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(404, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(405, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(406, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(407, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(408, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(409, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(410, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(411, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(412, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(413, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(414, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(415, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(416, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(417, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(418, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(419, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(420, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(421, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(422, 1, 'ACCOUNTS', 'Deleted Service Role to ACCOUNTS', '2025-03-28'),
(423, 1, 'ACCOUNTS', 'Deleted Service Role to ACCOUNTS', '2025-03-28'),
(424, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(425, 1, 'ACCOUNTS', 'Deleted Service Role to ACCOUNTS', '2025-03-28'),
(426, 1, 'ACCOUNTS', 'Deleted Service Role to ACCOUNTS', '2025-03-28'),
(427, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(428, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(429, 1, 'ACCOUNTS', 'Created Service Role to ACCOUNTS', '2025-03-28'),
(430, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(431, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(432, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(433, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(434, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(435, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(436, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(437, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(438, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(439, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(440, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(441, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(442, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(443, 1, 'SPECIFICACCOUNTBOOK', 'Assign Doctor to SPECIFICACCOUNTBOOK', '2025-03-28'),
(444, 1, 'SPECIFICACCOUNTBOOK', 'Assign Doctor to SPECIFICACCOUNTBOOK', '2025-03-28'),
(445, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(446, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(447, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(448, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(449, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(450, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(451, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(452, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(453, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(454, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(455, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(456, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(457, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(458, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(459, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(460, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(461, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(462, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(463, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(464, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(465, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(466, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(467, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(468, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-28'),
(469, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(470, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(471, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(472, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(473, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(474, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(475, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(476, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(477, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(478, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(479, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(480, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(481, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(482, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(483, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(484, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(485, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(486, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(487, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(488, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(489, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(490, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(491, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(492, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(493, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(494, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(495, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(496, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(497, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(498, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(499, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(500, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(501, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(502, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(503, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(504, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(505, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(506, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(507, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(508, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(509, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(510, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(511, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(512, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(513, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(514, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(515, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(516, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(517, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(518, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(519, 1, 'SPECIFICACCOUNTBOOK', 'Assign Doctor to SPECIFICACCOUNTBOOK', '2025-03-28'),
(520, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(521, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(522, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(523, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(524, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(525, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(526, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(527, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(528, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(529, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(530, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(531, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(532, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(533, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(534, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(535, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(536, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(537, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(538, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(539, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(540, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(541, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(542, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(543, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(544, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(545, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(546, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(547, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(548, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(549, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(550, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(551, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(552, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(553, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(554, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(555, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(556, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(557, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(558, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(559, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(560, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(561, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-28'),
(562, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-28'),
(563, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(564, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(565, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(566, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(567, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(568, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(569, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(570, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(571, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(572, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(573, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(574, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(575, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(576, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(577, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(578, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(579, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(580, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(581, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(582, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(583, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(584, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(585, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(586, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(587, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(588, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(589, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(590, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(591, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(592, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(593, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(594, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(595, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(596, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(597, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(598, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(599, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(600, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(601, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(602, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(603, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(604, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(605, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(606, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(607, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(608, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(609, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(610, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(611, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(612, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(613, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(614, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(615, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(616, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(617, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(618, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(619, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(620, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(621, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(622, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(623, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(624, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(625, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(626, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(627, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(628, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(629, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(630, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(631, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(632, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(633, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(634, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(635, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(636, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(637, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(638, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(639, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(640, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(641, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(642, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(643, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(644, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(645, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(646, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(647, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(648, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(649, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(650, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(651, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(652, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(653, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(654, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(655, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(656, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(657, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(658, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(659, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(660, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(661, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(662, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(663, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(664, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(665, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(666, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(667, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(668, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(669, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(670, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(671, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(672, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(673, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(674, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(675, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(676, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(677, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(678, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(679, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(680, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(681, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(682, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(683, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(684, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(685, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(686, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(687, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(688, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(689, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(690, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(691, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(692, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(693, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(694, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(695, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(696, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(697, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(698, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(699, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(700, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(701, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(702, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(703, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(704, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(705, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(706, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(707, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(708, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(709, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(710, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(711, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(712, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(713, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(714, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(715, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(716, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(717, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-28'),
(718, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-28'),
(719, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(720, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(721, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(722, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(723, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(724, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(725, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(726, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(727, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(728, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-28'),
(729, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(730, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(731, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(732, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(733, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(734, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(735, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(736, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(737, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(738, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(739, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(740, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(741, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(742, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(743, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(744, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(745, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(746, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(747, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(748, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(749, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(750, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(751, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(752, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(753, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(754, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(755, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(756, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(757, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(758, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(759, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(760, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(761, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(762, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(763, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(764, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(765, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(766, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(767, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(768, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(769, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(770, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(771, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(772, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(773, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(774, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(775, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(776, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(777, 1, 'BILLING', 'Navigate to BILLING', '2025-03-28'),
(778, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-28'),
(779, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(780, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(781, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(782, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(783, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(784, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(785, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(786, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(787, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(788, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(789, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(790, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(791, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(792, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(793, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(794, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(795, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(796, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(797, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(798, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(799, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(800, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(801, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(802, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(803, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-28'),
(804, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-28'),
(805, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-28'),
(806, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(807, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-28'),
(808, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-28'),
(809, 1, 'HOME', 'Navigate to HOME', '2025-03-28'),
(810, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(811, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(812, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-28'),
(813, 1, 'HOME', 'Navigate to HOME', '2025-03-28');
INSERT INTO `clinic_account_owner_history` (`actid`, `account_id`, `page`, `account_activity`, `date_created`) VALUES
(814, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-28'),
(815, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(816, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(817, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(818, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(819, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(820, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(821, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(822, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-29'),
(823, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(824, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(825, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-29'),
(826, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-29'),
(827, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(828, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(829, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(830, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(831, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(832, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(833, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(834, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(835, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(836, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(837, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(838, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(839, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(840, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(841, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(842, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(843, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(844, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(845, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(846, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(847, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(848, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(849, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(850, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(851, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(852, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(853, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(854, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(855, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(856, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(857, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(858, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(859, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(860, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(861, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(862, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(863, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(864, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(865, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(866, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(867, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(868, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(869, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(870, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(871, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(872, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(873, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(874, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(875, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(876, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(877, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(878, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-29'),
(879, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(880, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-29'),
(881, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-29'),
(882, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-29'),
(883, 1, 'BILLING', 'Navigate to BILLING', '2025-03-29'),
(884, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-29'),
(885, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(886, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(887, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(888, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-29'),
(889, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(890, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(891, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(892, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(893, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-29'),
(894, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-29'),
(895, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-29'),
(896, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-29'),
(897, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-29'),
(898, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-29'),
(899, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-29'),
(900, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-29'),
(901, 1, 'LOGOUT', 'Navigate to LOGOUT', '2025-03-29'),
(902, 1, 'LOGOUT', 'Navigate to LOGOUT', '2025-03-29'),
(903, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(904, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(905, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(906, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(907, 1, 'LOGOUT', 'Navigate to LOGOUT', '2025-03-29'),
(908, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(909, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(910, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(911, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(912, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(913, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(914, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-29'),
(915, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(916, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-29'),
(917, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-29'),
(918, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-29'),
(919, 1, 'BILLING', 'Navigate to BILLING', '2025-03-29'),
(920, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-29'),
(921, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(922, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(923, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(924, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(925, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(926, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(927, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(928, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(929, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(930, 1, 'SPECIFICACCOUNTBOOK', 'Assign Doctor to SPECIFICACCOUNTBOOK', '2025-03-29'),
(931, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(932, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(933, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(934, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(935, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(936, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(937, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(938, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-29'),
(939, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-29'),
(940, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-29'),
(941, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-29'),
(942, 1, 'SPECIFICACCOUNTBOOK', 'Assign Doctor to SPECIFICACCOUNTBOOK', '2025-03-29'),
(943, 1, 'PATIENT', 'Create Patient on PATIENT', '2025-03-29'),
(944, 1, 'PATIENT', 'Create Patient on PATIENT', '2025-03-29'),
(945, 1, 'SPECIFICACCOUNTBOOK', 'Assign Doctor to SPECIFICACCOUNTBOOK', '2025-03-29'),
(946, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(947, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(948, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(949, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(950, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(951, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(952, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(953, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(954, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(955, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(956, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(957, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(958, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(959, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-29'),
(960, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-29'),
(961, 1, 'BILLING', 'Navigate to BILLING', '2025-03-29'),
(962, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-29'),
(963, 1, 'BILLING', 'Navigate to BILLING', '2025-03-29'),
(964, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-29'),
(965, 1, 'BILLING', 'Navigate to BILLING', '2025-03-29'),
(966, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(967, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(968, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(969, 1, 'ACTIVITYLOGS', 'Navigate to ACTIVITYLOGS', '2025-03-29'),
(970, 1, 'ACTIVITYLOGS', 'Navigate to ACTIVITYLOGS', '2025-03-29'),
(971, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(972, 1, 'ACTIVITYLOGS', 'Navigate to ACTIVITYLOGS', '2025-03-29'),
(973, 1, 'ACTIVITYLOGS', 'Navigate to ACTIVITYLOGS', '2025-03-29'),
(974, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-29'),
(975, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-29'),
(976, 1, 'STAFFLOGS', 'Navigate to STAFFLOGS', '2025-03-29'),
(977, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-29'),
(978, 1, 'STAFFLOGS', 'Navigate to STAFFLOGS', '2025-03-29'),
(979, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(980, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-29'),
(981, 1, 'STAFFLOGS', 'Navigate to STAFFLOGS', '2025-03-29'),
(982, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(983, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(984, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-29'),
(985, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-29'),
(986, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-29'),
(987, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(988, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(989, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(990, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(991, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(992, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(993, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(994, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(995, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(996, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(997, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(998, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(999, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-29'),
(1000, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(1001, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(1002, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-29'),
(1003, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(1004, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-29'),
(1005, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-29'),
(1006, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-29'),
(1007, 1, 'BILLING', 'Navigate to BILLING', '2025-03-29'),
(1008, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-29'),
(1009, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-29'),
(1010, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(1011, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(1012, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(1013, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-29'),
(1014, 1, 'BILLING', 'Navigate to BILLING', '2025-03-29'),
(1015, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-29'),
(1016, 1, 'STAFFLOGS', 'Navigate to STAFFLOGS', '2025-03-29'),
(1017, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(1018, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(1019, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-29'),
(1020, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(1021, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(1022, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-29'),
(1023, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(1024, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(1025, 1, 'ACTIVITYLOGS', 'Navigate to ACTIVITYLOGS', '2025-03-29'),
(1026, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(1027, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(1028, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(1029, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(1030, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-29'),
(1031, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(1032, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-29'),
(1033, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-29'),
(1034, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(1035, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-29'),
(1036, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(1037, 1, 'ACTIVITYLOGS', 'Navigate to ACTIVITYLOGS', '2025-03-29'),
(1038, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(1039, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(1040, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-29'),
(1041, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-29'),
(1042, 1, 'BILLING', 'Navigate to BILLING', '2025-03-29'),
(1043, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-29'),
(1044, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(1045, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-29'),
(1046, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-29'),
(1047, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-29'),
(1048, 1, 'BILLING', 'Navigate to BILLING', '2025-03-29'),
(1049, 1, 'BILLING', 'Navigate to BILLING', '2025-03-29'),
(1050, 1, 'BILLING', 'Navigate to BILLING', '2025-03-29'),
(1051, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(1052, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(1053, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-29'),
(1054, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(1055, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-29'),
(1056, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-29'),
(1057, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-29'),
(1058, 1, 'BILLING', 'Navigate to BILLING', '2025-03-29'),
(1059, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-29'),
(1060, 1, 'BILLING', 'Navigate to BILLING', '2025-03-29'),
(1061, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-29'),
(1062, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(1063, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(1064, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(1065, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(1066, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(1067, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-29'),
(1068, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(1069, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(1070, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(1071, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(1072, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-29'),
(1073, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(1074, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(1075, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(1076, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(1077, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-29'),
(1078, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-29'),
(1079, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-29'),
(1080, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-29'),
(1081, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(1082, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(1083, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(1084, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(1085, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(1086, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(1087, 1, 'PATIENT', 'Updated Status Integration on PATIENT', '2025-03-29'),
(1088, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(1089, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(1090, 1, 'HOME', 'Navigate to HOME', '2025-03-30'),
(1091, 1, 'HOME', 'Navigate to HOME', '2025-03-30'),
(1092, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-30'),
(1093, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1094, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-30'),
(1095, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-30'),
(1096, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-30'),
(1097, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-30'),
(1098, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-30'),
(1099, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-30'),
(1100, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1101, 1, 'BILLING', 'Navigate to BILLING', '2025-03-30'),
(1102, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-30'),
(1103, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1104, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1105, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1106, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1107, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1108, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1109, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1110, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1111, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1112, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1113, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1114, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1115, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1116, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1117, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1118, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1119, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-30'),
(1120, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1121, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1122, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1123, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1124, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1125, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1126, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1127, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1128, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1129, 1, 'SUPPORTSPECIFICRESPONSE', 'Navigate to SUPPORTSPECIFICRESPONSE', '2025-03-30'),
(1130, 1, 'HOME', 'Navigate to HOME', '2025-03-30'),
(1131, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1132, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-30'),
(1133, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-30'),
(1134, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-30'),
(1135, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-30'),
(1136, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-30'),
(1137, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-03-30'),
(1138, 1, 'HOME', 'Navigate to HOME', '2025-03-30'),
(1139, 1, 'HOME', 'Navigate to HOME', '2025-03-30'),
(1140, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1141, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-30'),
(1142, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1143, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1144, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1145, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1146, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1147, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1148, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1149, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1150, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1151, 1, 'SUPPORTSPECIFICRESPONSE', 'Navigate to SUPPORTSPECIFICRESPONSE', '2025-03-30'),
(1152, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1153, 1, 'SUPPORTSPECIFICRESPONSE', 'Navigate to SUPPORTSPECIFICRESPONSE', '2025-03-30'),
(1154, 1, 'SUPPORTSPECIFICRESPONSE', 'Navigate to SUPPORTSPECIFICRESPONSE', '2025-03-30'),
(1155, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1156, 1, 'SUPPORTSPECIFICRESPONSE', 'Navigate to SUPPORTSPECIFICRESPONSE', '2025-03-30'),
(1157, 1, 'SUPPORTSPECIFICRESPONSE', 'Navigate to SUPPORTSPECIFICRESPONSE', '2025-03-30'),
(1158, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1159, 1, 'SUPPORTSPECIFICRESPONSE', 'Navigate to SUPPORTSPECIFICRESPONSE', '2025-03-30'),
(1160, 1, 'SUPPORTSPECIFICRESPONSE', 'Navigate to SUPPORTSPECIFICRESPONSE', '2025-03-30'),
(1161, 1, 'SUPPORTSPECIFICRESPONSE', 'Navigate to SUPPORTSPECIFICRESPONSE', '2025-03-30'),
(1162, 1, 'SUPPORTSPECIFICRESPONSE', 'Navigate to SUPPORTSPECIFICRESPONSE', '2025-03-30'),
(1163, 1, 'SUPPORTSPECIFICRESPONSE', 'Navigate to SUPPORTSPECIFICRESPONSE', '2025-03-30'),
(1164, 1, 'HOME', 'Navigate to HOME', '2025-03-30'),
(1165, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1166, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1167, 1, 'PATIENT', 'Create Patient on PATIENT', '2025-03-30'),
(1168, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1169, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1170, 1, 'PATIENT', 'Updated Status Integration on PATIENT', '2025-03-30'),
(1171, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1172, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1173, 1, 'PATIENT', 'Updated Patient on PATIENT', '2025-03-30'),
(1174, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1175, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1176, 1, 'PATIENT', 'Delete Patient on PATIENT', '2025-03-30'),
(1177, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1178, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1179, 1, 'PATIENT', 'Create Patient on PATIENT', '2025-03-30'),
(1180, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1181, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1182, 1, 'PATIENT', 'Updated Status Integration on PATIENT', '2025-03-30'),
(1183, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1184, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1185, 1, 'ACTIVITYLOGS', 'Navigate to ACTIVITYLOGS', '2025-03-30'),
(1186, 1, 'ACTIVITYLOGS', 'Navigate to ACTIVITYLOGS', '2025-03-30'),
(1187, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1188, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1189, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1190, 1, 'SPECIFICACCOUNTBOOK', 'Assign Doctor to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1191, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1192, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1193, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1194, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1195, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1196, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(1197, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1198, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1199, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-30'),
(1200, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1201, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1202, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-30'),
(1203, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-30'),
(1204, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-30'),
(1205, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-30'),
(1206, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1207, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1208, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-30'),
(1209, 1, 'SERVICE', 'Created Service on SERVICE', '2025-03-30'),
(1210, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-30'),
(1211, 1, 'SERVICE', 'Created Service on SERVICE', '2025-03-30'),
(1212, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-30'),
(1213, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-30'),
(1214, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1215, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1216, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-30'),
(1217, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-30'),
(1218, 1, 'SERVICE', 'Deleted Service on SERVICE', '2025-03-30'),
(1219, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-30'),
(1220, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-30'),
(1221, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1222, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-30'),
(1223, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1224, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1225, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-30'),
(1226, 1, 'SERVICE', 'Updated Service on SERVICE', '2025-03-30'),
(1227, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-30'),
(1228, 1, 'SERVICE', 'Navigate to SERVICE', '2025-03-30'),
(1229, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1230, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1231, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-30'),
(1232, 1, 'HOME', 'Navigate to HOME', '2025-03-30'),
(1233, 1, 'HOME', 'Navigate to HOME', '2025-03-30'),
(1234, 1, 'REPORTS', 'Navigate to REPORTS', '2025-03-30'),
(1235, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-03-30'),
(1236, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1237, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1238, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1239, 1, 'ACCOUNTS', 'Created New Account to ACCOUNTS', '2025-03-30'),
(1240, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1241, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1242, 1, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-03-30'),
(1243, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1244, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1245, 1, 'ACCOUNTS', 'Added Paygrade Accounts to ACCOUNTS', '2025-03-30'),
(1246, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1247, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1248, 1, 'ACCOUNTS', 'Added Paygrade Accounts to ACCOUNTS', '2025-03-30'),
(1249, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1250, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1251, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1252, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1253, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(1254, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1255, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1256, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1257, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1258, 1, 'ACCOUNTS', 'Created Service Role to ACCOUNTS', '2025-03-30'),
(1259, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1260, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1261, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1262, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1263, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1264, 1, 'STAFFLOGS', 'Navigate to STAFFLOGS', '2025-03-30'),
(1265, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1266, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-30'),
(1267, 1, 'BILLING', 'Navigate to BILLING', '2025-03-30'),
(1268, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-03-30'),
(1269, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1270, 1, 'SUPPORTSPECIFICRESPONSE', 'Navigate to SUPPORTSPECIFICRESPONSE', '2025-03-30'),
(1271, 1, 'SUPPORTSPECIFICRESPONSE', 'Navigate to SUPPORTSPECIFICRESPONSE', '2025-03-30'),
(1272, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-03-30'),
(1273, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-30'),
(1274, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-30'),
(1275, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-30'),
(1276, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1277, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1278, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(1279, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(1280, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1281, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1282, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1283, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(1284, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1285, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1286, 1, 'SPECIFICACCOUNTBOOK', 'Assign Doctor to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1287, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1288, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1289, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(1290, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1291, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-03-30'),
(1292, 1, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(1293, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(1294, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(1295, 1, 'HOME', 'Navigate to HOME', '2025-04-04'),
(1296, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-04'),
(1297, 1, 'HOME', 'Navigate to HOME', '2025-04-04'),
(1298, 1, 'HOME', 'Navigate to HOME', '2025-04-04'),
(1299, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-04-04'),
(1300, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-04'),
(1301, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-04'),
(1302, 1, 'ACCOUNTS', 'Deleted Service Role to ACCOUNTS', '2025-04-04'),
(1303, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-04'),
(1304, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-04'),
(1305, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-04'),
(1306, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-04-04'),
(1307, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-04-04'),
(1308, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-04'),
(1309, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-04'),
(1310, 1, 'HOME', 'Navigate to HOME', '2025-04-05'),
(1311, 1, 'HOME', 'Navigate to HOME', '2025-04-12'),
(1312, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-12'),
(1313, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1314, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1315, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1316, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1317, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1318, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1319, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1320, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1321, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1322, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1323, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1324, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1325, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1326, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-12'),
(1327, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-12'),
(1328, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-12'),
(1329, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1330, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-12'),
(1331, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-12'),
(1332, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-12'),
(1333, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-12'),
(1334, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-12'),
(1335, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1336, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-12'),
(1337, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-12'),
(1338, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-12'),
(1339, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1340, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1341, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-12'),
(1342, 1, 'HOME', 'Navigate to HOME', '2025-04-12'),
(1343, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-12'),
(1344, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-12'),
(1345, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-12'),
(1346, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-12'),
(1347, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-12'),
(1348, 1, 'BILLING', 'Navigate to BILLING', '2025-04-12'),
(1349, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-12'),
(1350, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-12'),
(1351, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-12'),
(1352, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1353, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-13'),
(1354, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1355, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1356, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1357, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1358, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1359, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1360, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1361, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1362, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1363, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1364, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1365, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1366, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1367, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1368, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1369, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1370, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1371, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1372, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1373, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1374, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1375, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1376, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1377, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1378, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1379, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1380, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1381, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1382, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1383, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1384, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1385, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1386, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1387, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1388, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1389, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1390, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1391, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1392, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1393, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1394, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1395, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1396, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1397, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1398, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1399, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1400, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1401, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1402, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-13'),
(1403, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-13'),
(1404, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-13'),
(1405, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1406, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1407, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1408, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1409, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1410, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1411, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1412, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-13'),
(1413, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-13'),
(1414, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1415, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1416, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1417, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1418, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1419, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1420, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1421, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1422, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1423, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1424, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1425, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1426, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1427, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-13'),
(1428, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1429, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1430, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1431, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1432, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1433, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1434, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1435, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1436, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1437, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1438, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1439, 1, 'SPECIFICACCOUNTBOOK', 'Assign Doctor to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1440, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1441, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1442, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1443, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1444, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1445, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1446, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1447, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1448, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1449, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1450, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1451, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1452, 1, 'SPECIFICACCOUNTBOOK', 'Assign Doctor to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1453, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1454, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1455, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1456, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1457, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1458, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1459, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1460, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1461, 5, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1462, 5, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1463, 5, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-13'),
(1464, 5, 'SERVICE', 'Navigate to SERVICE', '2025-04-13'),
(1465, 5, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1466, 5, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-13'),
(1467, 5, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-13'),
(1468, 5, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-13'),
(1469, 5, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1470, 5, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-13'),
(1471, 5, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-13'),
(1472, 5, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-13'),
(1473, 5, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1474, 5, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1475, 5, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1476, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1477, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1478, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1479, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1480, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1481, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1482, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1483, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1484, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1485, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1486, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1487, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1488, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-13'),
(1489, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1490, 5, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1491, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1492, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1493, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1494, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1495, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1496, 5, 'ACCOUNTS', 'Created Service Role to ACCOUNTS', '2025-04-13'),
(1497, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1498, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1499, 5, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1500, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1501, 5, 'ACCOUNTS', 'Deleted Service Role to ACCOUNTS', '2025-04-13'),
(1502, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1503, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1504, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1505, 5, 'ACCOUNTS', 'Created Service Role to ACCOUNTS', '2025-04-13'),
(1506, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1507, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1508, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1509, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1510, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1511, 5, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1512, 5, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-13'),
(1513, 5, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1514, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1515, 5, 'BILLING', 'Navigate to BILLING', '2025-04-13'),
(1516, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1517, 5, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-13'),
(1518, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1519, 5, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1520, 5, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1521, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1522, 5, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-13'),
(1523, 5, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-13'),
(1524, 5, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1525, 5, 'SERVICE', 'Navigate to SERVICE', '2025-04-13'),
(1526, 5, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1527, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1528, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1529, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1530, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1531, 8, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1532, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1533, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1534, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1535, 8, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1536, 8, 'BILLING', 'Navigate to BILLING', '2025-04-13'),
(1537, 8, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-13'),
(1538, 8, 'INTEGRATION', 'Created New Integration to INTEGRATION', '2025-04-13'),
(1539, 8, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-13'),
(1540, 8, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-13'),
(1541, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1542, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1543, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1544, 8, 'ACCOUNTS', 'Created New Account to ACCOUNTS', '2025-04-13'),
(1545, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1546, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1547, 8, 'ACCOUNTS', 'Created New Account to ACCOUNTS', '2025-04-13'),
(1548, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1549, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1550, 8, 'ACCOUNTS', 'Created New Account to ACCOUNTS', '2025-04-13'),
(1551, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1552, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1553, 8, 'ACCOUNTS', 'Created New Account to ACCOUNTS', '2025-04-13'),
(1554, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1555, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1556, 8, 'ACCOUNTS', 'Update Accounts to ACCOUNTS', '2025-04-13'),
(1557, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1558, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1559, 8, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-04-13'),
(1560, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1561, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1562, 8, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-04-13'),
(1563, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1564, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1565, 8, 'ACCOUNTS', 'Added Paygrade Accounts to ACCOUNTS', '2025-04-13'),
(1566, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1567, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1568, 8, 'ACCOUNTS', 'Added Paygrade Accounts to ACCOUNTS', '2025-04-13'),
(1569, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1570, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1571, 8, 'ACCOUNTS', 'Added Paygrade Accounts to ACCOUNTS', '2025-04-13'),
(1572, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1573, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1574, 8, 'ACCOUNTS', 'Created Service Role to ACCOUNTS', '2025-04-13'),
(1575, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1576, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1577, 8, 'SERVICE', 'Navigate to SERVICE', '2025-04-13'),
(1578, 8, 'SERVICE', 'Created Service on SERVICE', '2025-04-13'),
(1579, 8, 'SERVICE', 'Navigate to SERVICE', '2025-04-13'),
(1580, 8, 'SERVICE', 'Navigate to SERVICE', '2025-04-13'),
(1581, 8, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-13'),
(1582, 8, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-13'),
(1583, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1584, 8, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-04-13'),
(1585, 8, 'PATIENT', 'Create Patient on PATIENT', '2025-04-13'),
(1586, 8, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1587, 8, 'PATIENT', 'Updated Status Integration on PATIENT', '2025-04-13'),
(1588, 8, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1589, 8, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1590, 8, 'SPECIFICACCOUNTBOOK', 'Assign Doctor to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1591, 8, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1592, 8, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1593, 8, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1594, 8, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1595, 8, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(1596, 8, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1597, 8, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1598, 8, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1599, 8, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-13'),
(1600, 8, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-13'),
(1601, 8, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-13'),
(1602, 8, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1603, 8, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-13');
INSERT INTO `clinic_account_owner_history` (`actid`, `account_id`, `page`, `account_activity`, `date_created`) VALUES
(1604, 8, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-13'),
(1605, 8, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-13'),
(1606, 8, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(1607, 8, 'BILLING', 'Navigate to BILLING', '2025-04-13'),
(1608, 8, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-13'),
(1609, 8, 'STAFFLOGS', 'Navigate to STAFFLOGS', '2025-04-13'),
(1610, 8, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-13'),
(1611, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1612, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-13'),
(1613, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-13'),
(1614, 8, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1615, 8, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-13'),
(1616, 8, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-13'),
(1617, 8, 'HOME', 'Navigate to HOME', '2025-04-13'),
(1618, 8, 'REPORTS', 'Navigate to REPORTS', '2025-04-13'),
(1619, 1, 'HOME', 'Navigate to HOME', '2025-04-15'),
(1620, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1621, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1622, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1623, 1, 'PATIENT', 'Delete Patient on PATIENT', '2025-04-15'),
(1624, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1625, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1626, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1627, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-15'),
(1628, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1629, 1, 'PATIENT', 'Create Patient on PATIENT', '2025-04-15'),
(1630, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1631, 1, 'BILLING', 'Navigate to BILLING', '2025-04-15'),
(1632, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1633, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1634, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1635, 1, 'ACCOUNTS', 'Created New Account to ACCOUNTS', '2025-04-15'),
(1636, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1637, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1638, 1, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-04-15'),
(1639, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1640, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1641, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1642, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1643, 1, 'ACCOUNTS', 'Created New Account to ACCOUNTS', '2025-04-15'),
(1644, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1645, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1646, 1, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-04-15'),
(1647, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1648, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1649, 1, 'ACCOUNTS', 'Update Accounts to ACCOUNTS', '2025-04-15'),
(1650, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1651, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1652, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1653, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1654, 1, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-04-15'),
(1655, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1656, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1657, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1658, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1659, 1, 'ACCOUNTS', 'Created New Account to ACCOUNTS', '2025-04-15'),
(1660, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1661, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1662, 1, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-04-15'),
(1663, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1664, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1665, 5, 'HOME', 'Navigate to HOME', '2025-04-15'),
(1666, 5, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1667, 1, 'HOME', 'Navigate to HOME', '2025-04-15'),
(1668, 1, 'HOME', 'Navigate to HOME', '2025-04-15'),
(1669, 1, 'HOME', 'Navigate to HOME', '2025-04-15'),
(1670, 1, 'HOME', 'Navigate to HOME', '2025-04-15'),
(1671, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1672, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-15'),
(1673, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-15'),
(1674, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1675, 1, 'PATIENT', 'Updated Status Integration on PATIENT', '2025-04-15'),
(1676, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1677, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1678, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-15'),
(1679, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-15'),
(1680, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-15'),
(1681, 1, 'HOME', 'Navigate to HOME', '2025-04-15'),
(1682, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-15'),
(1683, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-15'),
(1684, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-15'),
(1685, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1686, 1, 'BILLING', 'Navigate to BILLING', '2025-04-15'),
(1687, 1, 'BILLING', 'Navigate to BILLING', '2025-04-15'),
(1688, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-15'),
(1689, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-04-15'),
(1690, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-15'),
(1691, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1692, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1693, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1694, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1695, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1696, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1697, 1, 'ACCOUNTS', 'Update Accounts to ACCOUNTS', '2025-04-15'),
(1698, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1699, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1700, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1701, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1702, 1, 'ACCOUNTS', 'Update Accounts to ACCOUNTS', '2025-04-15'),
(1703, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1704, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1705, 1, 'ACCOUNTS', 'Created Service Role to ACCOUNTS', '2025-04-15'),
(1706, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1707, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1708, 1, 'ACCOUNTS', 'Created Service Role to ACCOUNTS', '2025-04-15'),
(1709, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1710, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1711, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1712, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1713, 1, 'ACCOUNTS', 'Update Accounts to ACCOUNTS', '2025-04-15'),
(1714, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1715, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1716, 1, 'ACCOUNTS', 'Created Service Role to ACCOUNTS', '2025-04-15'),
(1717, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1718, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1719, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-15'),
(1720, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1721, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(1722, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1723, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1724, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(1725, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-15'),
(1726, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(1727, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-15'),
(1728, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(1729, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1730, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(1731, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-15'),
(1732, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(1733, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1734, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1735, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1736, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1737, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1738, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1739, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(1740, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-15'),
(1741, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-15'),
(1742, 1, 'HOME', 'Navigate to HOME', '2025-04-15'),
(1743, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1744, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(1745, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1746, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1747, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1748, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1749, 1, 'ACCOUNTS', 'Update Accounts to ACCOUNTS', '2025-04-15'),
(1750, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1751, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1752, 1, 'ACCOUNTS', 'Added Paygrade Accounts to ACCOUNTS', '2025-04-15'),
(1753, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1754, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1755, 1, 'ACCOUNTS', 'Added Paygrade Accounts to ACCOUNTS', '2025-04-15'),
(1756, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1757, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1758, 1, 'ACCOUNTS', 'Created Service Role to ACCOUNTS', '2025-04-15'),
(1759, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1760, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1761, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-15'),
(1762, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(1763, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(1764, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-15'),
(1765, 1, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1766, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1767, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1768, 1, 'PATIENT', 'Create Patient on PATIENT', '2025-04-22'),
(1769, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1770, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1771, 1, 'PATIENT', 'Updated Status Integration on PATIENT', '2025-04-22'),
(1772, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1773, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1774, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1775, 1, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1776, 1, 'BILLING', 'Navigate to BILLING', '2025-04-22'),
(1777, 1, 'BILLING', 'Navigate to BILLING', '2025-04-22'),
(1778, 1, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1779, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1780, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1781, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1782, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(1783, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1784, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1785, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1786, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1787, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1788, 1, 'BILLING', 'Navigate to BILLING', '2025-04-22'),
(1789, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1790, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1791, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1792, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1793, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1794, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1795, 1, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1796, 1, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1797, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1798, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1799, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1800, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1801, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1802, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1803, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1804, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1805, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1806, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1807, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-22'),
(1808, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(1809, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(1810, 1, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1811, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1812, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(1813, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-22'),
(1814, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-22'),
(1815, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1816, 1, 'BILLING', 'Navigate to BILLING', '2025-04-22'),
(1817, 1, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1818, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1819, 1, 'BILLING', 'Navigate to BILLING', '2025-04-22'),
(1820, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1821, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1822, 1, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1823, 1, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1824, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-04-22'),
(1825, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-04-22'),
(1826, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-04-22'),
(1827, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-04-22'),
(1828, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-04-22'),
(1829, 1, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1830, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1831, 1, 'ACCOUNTS', 'Update Accounts to ACCOUNTS', '2025-04-22'),
(1832, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1833, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1834, 1, 'ACCOUNTS', 'Update Accounts to ACCOUNTS', '2025-04-22'),
(1835, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1836, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1837, 1, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1838, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-04-22'),
(1839, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1840, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1841, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1842, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1843, 10, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1844, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1845, 10, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1846, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1847, 10, 'PATIENT', 'Create Patient on PATIENT', '2025-04-22'),
(1848, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1849, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1850, 10, 'PATIENT', 'Updated Status Integration on PATIENT', '2025-04-22'),
(1851, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1852, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1853, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1854, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1855, 10, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1856, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1857, 10, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1858, 10, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(1859, 10, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1860, 10, 'SERVICE', 'Created Service on SERVICE', '2025-04-22'),
(1861, 10, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1862, 10, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1863, 10, 'SERVICE', 'Created Service on SERVICE', '2025-04-22'),
(1864, 10, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1865, 10, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1866, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1867, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1868, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1869, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1870, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1871, 10, 'ACCOUNTS', 'Created New Account to ACCOUNTS', '2025-04-22'),
(1872, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1873, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1874, 10, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-04-22'),
(1875, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1876, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1877, 10, 'ACCOUNTS', 'Added Paygrade Accounts to ACCOUNTS', '2025-04-22'),
(1878, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1879, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1880, 10, 'ACCOUNTS', 'Created New Account to ACCOUNTS', '2025-04-22'),
(1881, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1882, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1883, 10, 'ACCOUNTS', 'Added Paygrade Accounts to ACCOUNTS', '2025-04-22'),
(1884, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1885, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1886, 10, 'ACCOUNTS', 'Created Service Role to ACCOUNTS', '2025-04-22'),
(1887, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1888, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1889, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1890, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1891, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1892, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1893, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1894, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1895, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1896, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1897, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1898, 10, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-04-22'),
(1899, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1900, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1901, 10, 'ACCOUNTS', 'Created New Account to ACCOUNTS', '2025-04-22'),
(1902, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1903, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1904, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1905, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1906, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1907, 10, 'ACCOUNTS', 'Added Paygrade Accounts to ACCOUNTS', '2025-04-22'),
(1908, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1909, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1910, 10, 'ACCOUNTS', 'Added Paygrade Accounts to ACCOUNTS', '2025-04-22'),
(1911, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1912, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1913, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1914, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1915, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1916, 10, 'BILLING', 'Navigate to BILLING', '2025-04-22'),
(1917, 10, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1918, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1919, 10, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(1920, 10, 'INTEGRATION', 'Created New Integration to INTEGRATION', '2025-04-22'),
(1921, 10, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(1922, 10, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(1923, 10, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1924, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1925, 10, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1926, 10, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1927, 10, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(1928, 10, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-22'),
(1929, 10, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-22'),
(1930, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1931, 10, 'BILLING', 'Navigate to BILLING', '2025-04-22'),
(1932, 10, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(1933, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1934, 10, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1935, 10, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1936, 10, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(1937, 10, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-22'),
(1938, 10, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-22'),
(1939, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1940, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1941, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1942, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1943, 10, 'BILLING', 'Navigate to BILLING', '2025-04-22'),
(1944, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1945, 10, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-04-22'),
(1946, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1947, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1948, 10, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(1949, 10, 'SUPPORT', 'Navigate to SUPPORT', '2025-04-22'),
(1950, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1951, 10, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1952, 10, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1953, 10, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(1954, 10, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1955, 10, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1956, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1957, 10, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1958, 10, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1959, 10, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1960, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1961, 10, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1962, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1963, 10, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1964, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1965, 10, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1966, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1967, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1968, 10, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-22'),
(1969, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1970, 10, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1971, 10, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1972, 10, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(1973, 10, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-22'),
(1974, 10, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-22'),
(1975, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1976, 10, 'BILLING', 'Navigate to BILLING', '2025-04-22'),
(1977, 10, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(1978, 10, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(1979, 10, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1980, 10, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(1981, 10, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-22'),
(1982, 10, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(1983, 10, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(1984, 10, 'BILLING', 'Navigate to BILLING', '2025-04-22'),
(1985, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1986, 10, 'STAFFLOGS', 'Navigate to STAFFLOGS', '2025-04-22'),
(1987, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1988, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1989, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(1990, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1991, 10, 'HOME', 'Navigate to HOME', '2025-04-22'),
(1992, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(1993, 10, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1994, 10, 'BILLING', 'Navigate to BILLING', '2025-04-22'),
(1995, 10, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(1996, 10, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(1997, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(1998, 10, 'ACCOUNTS', 'Delete Accounts to ACCOUNTS', '2025-04-22'),
(1999, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(2000, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(2001, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2002, 10, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(2003, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2004, 10, 'HOME', 'Navigate to HOME', '2025-04-22'),
(2005, 10, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(2006, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2007, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2008, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2009, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2010, 10, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(2011, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2012, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2013, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2014, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2015, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(2016, 10, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(2017, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2018, 10, 'PATIENT', 'Delete Patient on PATIENT', '2025-04-22'),
(2019, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2020, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2021, 10, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(2022, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2023, 10, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(2024, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2025, 10, 'SUPPORT', 'Navigate to SUPPORT', '2025-04-22'),
(2026, 10, 'SUPPORT', 'Navigate to SUPPORT', '2025-04-22'),
(2027, 10, 'SUPPORT', 'Navigate to SUPPORT', '2025-04-22'),
(2028, 10, 'HOME', 'Navigate to HOME', '2025-04-22'),
(2029, 10, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(2030, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(2031, 10, 'BILLING', 'Navigate to BILLING', '2025-04-22'),
(2032, 10, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(2033, 10, 'SUPPORT', 'Navigate to SUPPORT', '2025-04-22'),
(2034, 10, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(2035, 10, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(2036, 10, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(2037, 10, 'INTEGRATION', 'Deleted Integration on INTEGRATION', '2025-04-22'),
(2038, 10, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(2039, 10, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(2040, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2041, 10, 'PATIENT', 'Create Patient on PATIENT', '2025-04-22'),
(2042, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2043, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2044, 10, 'PATIENT', 'Updated Status Integration on PATIENT', '2025-04-22'),
(2045, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2046, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2047, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2048, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2049, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2050, 10, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(2051, 10, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(2052, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2053, 10, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(2054, 10, 'INTEGRATION', 'Created New Integration to INTEGRATION', '2025-04-22'),
(2055, 10, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(2056, 10, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(2057, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2058, 10, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(2059, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2060, 10, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(2061, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2062, 10, 'HOME', 'Navigate to HOME', '2025-04-22'),
(2063, 10, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(2064, 10, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(2065, 10, 'HOME', 'Navigate to HOME', '2025-04-22'),
(2066, 10, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2067, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2068, 10, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-22'),
(2069, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2070, 10, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-22'),
(2071, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2072, 10, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-22'),
(2073, 10, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2074, 10, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-22'),
(2075, 10, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-22'),
(2076, 1, 'HOME', 'Navigate to HOME', '2025-04-22'),
(2077, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-04-22'),
(2078, 1, 'HOME', 'Navigate to HOME', '2025-04-22'),
(2079, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(2080, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2081, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2082, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2083, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2084, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-22'),
(2085, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2086, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2087, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2088, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2089, 1, 'HOME', 'Navigate to HOME', '2025-04-22'),
(2090, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2091, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(2092, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(2093, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(2094, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-22'),
(2095, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-04-22'),
(2096, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-22'),
(2097, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-22'),
(2098, 1, 'HOME', 'Navigate to HOME', '2025-04-22'),
(2099, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-22'),
(2100, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(2101, 1, 'BILLING', 'Navigate to BILLING', '2025-04-22'),
(2102, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(2103, 1, 'BILLING', 'Navigate to BILLING', '2025-04-22'),
(2104, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(2105, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-04-22'),
(2106, 1, 'SUPPORTSPECIFICRESPONSE', 'Navigate to SUPPORTSPECIFICRESPONSE', '2025-04-22'),
(2107, 1, 'SUPPORTSPECIFICRESPONSE', 'Navigate to SUPPORTSPECIFICRESPONSE', '2025-04-22'),
(2108, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-04-22'),
(2109, 1, 'HOME', 'Navigate to HOME', '2025-04-22'),
(2110, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2111, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-22'),
(2112, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-22'),
(2113, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-22'),
(2114, 1, 'INQUIRY', 'Navigate to INQUIRY', '2025-04-22'),
(2115, 1, 'ANNOUNCEMENT', 'Navigate to ANNOUNCEMENT', '2025-04-22'),
(2116, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(2117, 1, 'BILLING', 'Navigate to BILLING', '2025-04-22'),
(2118, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(2119, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-04-22'),
(2120, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(2121, 1, 'SUPPORT', 'Navigate to SUPPORT', '2025-04-22'),
(2122, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-22'),
(2123, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-04-22'),
(2124, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(2125, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(2126, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(2127, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(2128, 1, 'ACCOUNTS', 'Update Accounts to ACCOUNTS', '2025-04-22'),
(2129, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(2130, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-22'),
(2131, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(2132, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2133, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2134, 1, 'SPECIFICACCOUNTBOOK', 'Assign Doctor to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2135, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2136, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2137, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-22'),
(2138, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2139, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(2140, 1, 'HOME', 'Navigate to HOME', '2025-04-23'),
(2141, 1, 'HOME', 'Navigate to HOME', '2025-04-23'),
(2142, 1, 'HOME', 'Navigate to HOME', '2025-04-23'),
(2143, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-23'),
(2144, 1, 'ACCOUNTS', 'Verified/Unverified Accounts to ACCOUNTS', '2025-04-23'),
(2145, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-23'),
(2146, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-23'),
(2147, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-23'),
(2148, 1, 'ACCOUNTS', 'Update Accounts to ACCOUNTS', '2025-04-23'),
(2149, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-23'),
(2150, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-23'),
(2151, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2152, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2153, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(2154, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(2155, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2156, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2157, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-23'),
(2158, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2159, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2160, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2161, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-23'),
(2162, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2163, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2164, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-23'),
(2165, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-23'),
(2166, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-23'),
(2167, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-23'),
(2168, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-23'),
(2169, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2170, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-23'),
(2171, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2172, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2173, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2174, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-23'),
(2175, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2176, 1, 'HOME', 'Navigate to HOME', '2025-04-23'),
(2177, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2178, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2179, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2180, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2181, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2182, 1, 'HOME', 'Navigate to HOME', '2025-04-23'),
(2183, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-23'),
(2184, 1, 'HOME', 'Navigate to HOME', '2025-04-23'),
(2185, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2186, 1, 'PATIENT', 'Create Patient on PATIENT', '2025-04-23'),
(2187, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2188, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2189, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-04-23'),
(2190, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2191, 1, 'PATIENT', 'Create Patient on PATIENT', '2025-04-23'),
(2192, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2193, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2194, 1, 'PATIENT', 'Create Patient on PATIENT', '2025-04-23'),
(2195, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2196, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2197, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2198, 1, 'PATIENT', 'Create Patient on PATIENT', '2025-04-23'),
(2199, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2200, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2201, 1, 'PATIENT', 'Create Patient on PATIENT', '2025-04-23'),
(2202, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2203, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2204, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-23'),
(2205, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2206, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-04-23'),
(2207, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2208, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2209, 1, 'HOME', 'Navigate to HOME', '2025-04-23'),
(2210, 1, 'HOME', 'Navigate to HOME', '2025-04-23'),
(2211, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2212, 1, 'HOME', 'Navigate to HOME', '2025-04-23'),
(2213, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2214, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2215, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2216, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2217, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2218, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2219, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(2220, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2221, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(2222, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2223, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(2224, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2225, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2226, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2227, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2228, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2229, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(2230, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2231, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2232, 1, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(2233, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2234, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-23'),
(2235, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2236, 1, 'PATIENT', 'Delete Patient on PATIENT', '2025-04-23'),
(2237, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2238, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2239, 1, 'PATIENT', 'Delete Patient on PATIENT', '2025-04-23'),
(2240, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2241, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2242, 1, 'PATIENT', 'Delete Patient on PATIENT', '2025-04-23'),
(2243, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2244, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2245, 1, 'PATIENT', 'Delete Patient on PATIENT', '2025-04-23'),
(2246, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2247, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2248, 1, 'PATIENT', 'Delete Patient on PATIENT', '2025-04-23'),
(2249, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2250, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2251, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-23'),
(2252, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-23'),
(2253, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-23'),
(2254, 1, 'BILLING', 'Navigate to BILLING', '2025-04-23'),
(2255, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2256, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-23'),
(2257, 1, 'ACCOUNTS', 'Update Accounts to ACCOUNTS', '2025-04-23'),
(2258, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-23'),
(2259, 1, 'ACCOUNTS', 'Navigate to ACCOUNTS', '2025-04-23'),
(2260, 1, 'REPORTS', 'Navigate to REPORTS', '2025-04-23'),
(2261, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-23'),
(2262, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(2263, 1, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-04-23'),
(2264, 1, 'SERVICE', 'Navigate to SERVICE', '2025-04-23'),
(2265, 1, 'INTEGRATION', 'Navigate to INTEGRATION', '2025-04-23'),
(2266, 1, 'BILLING', 'Navigate to BILLING', '2025-04-23'),
(2267, 1, 'PATIENT', 'Navigate to PATIENT', '2025-04-23');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_account_patient_history`
--

CREATE TABLE `clinic_account_patient_history` (
  `actid` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `page` varchar(255) NOT NULL,
  `account_activity` varchar(255) NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_account_patient_history`
--

INSERT INTO `clinic_account_patient_history` (`actid`, `account_id`, `client_id`, `page`, `account_activity`, `date_created`) VALUES
(1, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(2, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(3, 1, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(4, 1, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(5, 1, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(6, 1, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(7, 1, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(8, 1, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(9, 1, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(10, 1, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(11, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(12, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(13, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(14, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(15, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(16, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(17, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(18, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(19, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(20, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(21, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(22, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(23, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(24, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(25, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(26, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(27, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(28, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(29, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(30, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(31, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(32, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(33, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(34, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(35, 1, 1, 'BOOK', 'Navigate to BOOK', '2025-03-29'),
(36, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(37, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(38, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(39, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(40, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(41, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(42, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(43, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(44, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(45, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(46, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(47, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(48, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(49, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(50, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(51, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(52, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(53, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(54, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(55, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(56, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(57, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(58, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(59, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(60, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(61, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(62, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(63, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(64, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(65, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(66, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(67, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(68, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(69, 1, 1, 'BOOK', 'Navigate to BOOK', '2025-03-29'),
(70, 1, 1, 'BOOK', 'Navigate to BOOK', '2025-03-29'),
(71, 1, 1, 'BOOK', 'Navigate to BOOK', '2025-03-29'),
(72, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(73, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(74, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(75, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(76, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(77, 1, 1, 'BOOK', 'Navigate to BOOK', '2025-03-29'),
(78, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(79, 1, 1, 'BOOK', 'Navigate to BOOK', '2025-03-29'),
(80, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(81, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(82, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(83, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(84, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(85, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(86, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(87, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(88, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(89, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(90, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(91, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(92, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(93, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(94, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(95, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(96, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(97, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(98, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(99, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(100, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(101, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(102, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(103, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(104, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(105, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(106, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(107, 1, 1, 'BOOK', 'Navigate to BOOK', '2025-03-29'),
(108, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(109, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(110, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(111, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(112, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(113, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(114, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(115, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(116, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(117, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(118, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(119, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(120, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(121, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(122, 1, 1, 'BOOK', 'Navigate to BOOK', '2025-03-29'),
(123, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(124, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(125, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(126, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(127, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(128, 1, 1, 'BOOK', 'Navigate to BOOK', '2025-03-29'),
(129, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(130, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(131, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(132, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(133, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(134, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(135, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(136, 1, 1, 'BOOK', 'Navigate to BOOK', '2025-03-29'),
(137, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(138, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(139, 1, 1, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(140, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(141, 1, 1, 'HOME', 'Navigate to HOME', '2025-03-29'),
(142, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-29'),
(143, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(144, 1, 3, 'BOOK', 'Navigate to BOOK', '2025-03-29'),
(145, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(146, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(147, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-29'),
(148, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(149, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(150, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(151, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(152, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-29'),
(153, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(154, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(155, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(156, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(157, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-30'),
(158, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(159, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-30'),
(160, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(161, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(162, 1, 3, 'BOOK', 'Navigate to BOOK', '2025-03-30'),
(163, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-30'),
(164, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(165, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-30'),
(166, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(167, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-30'),
(168, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(169, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(170, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(171, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-30'),
(172, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(173, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(174, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(175, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(176, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-30'),
(177, 1, 3, 'BOOK', 'Navigate to BOOK', '2025-03-30'),
(178, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-30'),
(179, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(180, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(181, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-30'),
(182, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(183, 1, 3, 'BOOK', 'Navigate to BOOK', '2025-03-30'),
(184, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(185, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(186, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-30'),
(187, 1, 3, 'BOOK', 'Navigate to BOOK', '2025-03-30'),
(188, 1, 3, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-30'),
(189, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(190, 1, 3, 'BOOK', 'Navigate to BOOK', '2025-03-30'),
(191, 1, 3, 'BOOK', 'Navigate to BOOK', '2025-03-30'),
(192, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(193, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-30'),
(194, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(195, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(196, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(197, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(198, 1, 3, 'HISTORY', 'Navigate to HISTORY', '2025-03-30'),
(199, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(200, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(201, 1, 3, 'HOME', 'Navigate to HOME', '2025-03-30'),
(202, 1, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(203, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-04-13'),
(204, 1, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-13'),
(205, 1, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(206, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-04-13'),
(207, 1, 1, 'BOOK', 'Navigate to BOOK', '2025-04-13'),
(208, 1, 1, 'BOOK', 'Navigate to BOOK', '2025-04-13'),
(209, 1, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(210, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-04-13'),
(211, 1, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-13'),
(212, 1, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-13'),
(213, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-04-13'),
(214, 1, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-13'),
(215, 1, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(216, 1, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(217, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-04-13'),
(218, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-04-13'),
(219, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-04-13'),
(220, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-04-13'),
(221, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-04-13'),
(222, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-04-13'),
(223, 1, 1, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-13'),
(224, 1, 1, 'HOME', 'Navigate to HOME', '2025-04-13'),
(225, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-04-13'),
(226, 1, 1, 'HISTORY', 'Navigate to HISTORY', '2025-04-13'),
(227, 8, 6, 'HOME', 'Navigate to HOME', '2025-04-13'),
(228, 8, 6, 'HOME', 'Navigate to HOME', '2025-04-13'),
(229, 8, 6, 'HOME', 'Navigate to HOME', '2025-04-13'),
(230, 8, 6, 'HOME', 'Navigate to HOME', '2025-04-13'),
(231, 8, 6, 'HOME', 'Navigate to HOME', '2025-04-13'),
(232, 8, 6, 'HOME', 'Navigate to HOME', '2025-04-13'),
(233, 8, 6, 'HISTORY', 'Navigate to HISTORY', '2025-04-13'),
(234, 8, 6, 'HISTORY', 'Navigate to HISTORY', '2025-04-13'),
(235, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-15'),
(236, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-15'),
(237, 1, 5, 'BOOK', 'Navigate to BOOK', '2025-04-15'),
(238, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-15'),
(239, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-15'),
(240, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-15'),
(241, 1, 5, 'BOOK', 'Navigate to BOOK', '2025-04-15'),
(242, 1, 5, 'BOOK', 'Navigate to BOOK', '2025-04-15'),
(243, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-15'),
(244, 1, 5, 'BOOK', 'Navigate to BOOK', '2025-04-15'),
(245, 1, 5, 'BOOK', 'Navigate to BOOK', '2025-04-15'),
(246, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-15'),
(247, 1, 8, 'HOME', 'Navigate to HOME', '2025-04-22'),
(248, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-22'),
(249, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-22'),
(250, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-22'),
(251, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-22'),
(252, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-22'),
(253, 1, 5, 'BOOK', 'Navigate to BOOK', '2025-04-22'),
(254, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-22'),
(255, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-22'),
(256, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-22'),
(257, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-22'),
(258, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-22'),
(259, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-22'),
(260, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-22'),
(261, 1, 5, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-22'),
(262, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-22'),
(263, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-22'),
(264, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-22'),
(265, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-22'),
(266, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-22'),
(267, 1, 5, 'BOOK', 'Navigate to BOOK', '2025-04-22'),
(268, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-22'),
(269, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-22'),
(270, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-22'),
(271, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-22'),
(272, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-22'),
(273, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-22'),
(274, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-22'),
(275, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-22'),
(276, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-22'),
(277, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-22'),
(278, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-22'),
(279, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-22'),
(280, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-22'),
(281, 1, 5, 'BOOK', 'Navigate to BOOK', '2025-04-22'),
(282, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-22'),
(283, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-23'),
(284, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-23'),
(285, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-23'),
(286, 1, 5, 'BOOK', 'Navigate to BOOK', '2025-04-23'),
(287, 1, 5, 'BOOK', 'Navigate to BOOK', '2025-04-23'),
(288, 1, 5, 'HOME', 'Navigate to HOME', '2025-04-23'),
(289, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-23'),
(290, 1, 5, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(291, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-23'),
(292, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-23'),
(293, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-23'),
(294, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-23'),
(295, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-23'),
(296, 1, 5, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(297, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-23'),
(298, 1, 5, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(299, 1, 5, 'HISTORY', 'Navigate to HISTORY', '2025-04-23'),
(300, 1, 5, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_account_payment`
--

CREATE TABLE `clinic_account_payment` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `payment_status` varchar(255) NOT NULL,
  `payment_response` text NOT NULL,
  `create_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinic_account_product`
--

CREATE TABLE `clinic_account_product` (
  `id` int(8) NOT NULL,
  `account_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `image` text NOT NULL,
  `price` double(10,2) NOT NULL,
  `quantity` int(50) NOT NULL,
  `status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `clinic_account_product`
--

INSERT INTO `clinic_account_product` (`id`, `account_id`, `name`, `code`, `image`, `price`, `quantity`, `status`) VALUES
(1, 1, 'Medicine 01', '7116', 'uploads/1742302638_images.jpeg', 150.00, 10, 'Available'),
(2, 1, 'Medicine 02', '9536', 'uploads/1742302652_images.jpeg', 150.00, 10, 'Available'),
(3, 1, 'Medicine 03', '9602', 'uploads/1742302666_images.jpeg', 150.00, 10, 'Available');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_account_staff_history`
--

CREATE TABLE `clinic_account_staff_history` (
  `actid` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `page` varchar(255) NOT NULL,
  `account_activity` varchar(255) NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_account_staff_history`
--

INSERT INTO `clinic_account_staff_history` (`actid`, `account_id`, `user_id`, `page`, `account_activity`, `date_created`) VALUES
(134, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(135, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(136, 1, 2, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(137, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(138, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(139, 1, 2, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(140, 1, 2, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(141, 1, 2, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(142, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(143, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(144, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(145, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(146, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(147, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(148, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(149, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(150, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(151, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(152, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(153, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(154, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(155, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(156, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(157, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(158, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(159, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(160, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(161, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(162, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(163, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(164, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(165, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(166, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(167, 1, 2, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(168, 1, 2, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(169, 1, 2, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(170, 1, 2, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(171, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(172, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(173, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(174, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(175, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(176, 1, 2, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(177, 1, 2, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(178, 1, 2, 'REPORTS', 'Navigate to REPORTS', '2025-03-29'),
(179, 1, 2, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(180, 1, 2, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(181, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(182, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(183, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(184, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(185, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(186, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(187, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(188, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(189, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(190, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(191, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(192, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(193, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(194, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(195, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(196, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(197, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(198, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(199, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(200, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(201, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(202, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(203, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(204, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(205, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(206, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(207, 1, 2, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(208, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(209, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(210, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(211, 1, 2, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(212, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(213, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(214, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(215, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(216, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(217, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(218, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(219, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(220, 1, 2, 'SCHEDULING', 'Navigate to SCHEDULING', '2025-03-29'),
(221, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(222, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(223, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(224, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(225, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(226, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(227, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(228, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(229, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(230, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(231, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(232, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(233, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(234, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(235, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(236, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(237, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(238, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(239, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(240, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(241, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(242, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(243, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(244, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(245, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(246, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(247, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(248, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(249, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(250, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(251, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(252, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(253, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(254, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(255, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(256, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(257, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(258, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(259, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(260, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(261, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(262, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(263, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(264, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(265, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(266, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(267, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(268, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(269, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(270, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(271, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(272, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(273, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(274, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(275, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(276, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(277, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(278, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(279, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(280, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(281, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(282, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(283, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(284, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(285, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(286, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(287, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(288, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(289, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(290, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(291, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(292, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(293, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(294, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(295, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(296, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(297, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(298, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(299, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(300, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(301, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(302, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(303, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(304, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(305, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(306, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(307, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(308, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(309, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(310, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(311, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(312, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(313, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(314, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(315, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(316, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(317, 1, 2, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(318, 1, 2, 'MYACCOUNT', 'Navigate to MYACCOUNT', '2025-03-29'),
(319, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(320, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(321, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(322, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(323, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(324, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(325, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(326, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(327, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(328, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(329, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(330, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(331, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(332, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(333, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(334, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(335, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(336, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(337, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(338, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(339, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(340, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(341, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(342, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(343, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(344, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(345, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(346, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(347, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(348, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(349, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(350, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(351, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(352, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(353, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(354, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(355, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(356, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(357, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(358, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(359, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(360, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(361, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(362, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(363, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(364, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(365, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(366, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(367, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(368, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(369, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(370, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(371, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(372, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(373, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(374, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(375, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(376, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(377, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(378, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(379, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(380, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(381, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(382, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(383, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(384, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-29'),
(385, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(386, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(387, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(388, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(389, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(390, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-29'),
(391, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-29'),
(392, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-29'),
(393, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-30'),
(394, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-30'),
(395, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-30'),
(396, 1, 2, 'HOME', 'Navigate to HOME', '2025-03-30'),
(397, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(398, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(399, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(400, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-03-30'),
(401, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(402, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(403, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(404, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(405, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(406, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(407, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-03-30'),
(408, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(409, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-03-30'),
(410, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-13'),
(411, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(412, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(413, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-13'),
(414, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(415, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-13'),
(416, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-13'),
(417, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-13'),
(418, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(419, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(420, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(421, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(422, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(423, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(424, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(425, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-13'),
(426, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-13'),
(427, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(428, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(429, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-13'),
(430, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-13'),
(431, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-13'),
(432, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(433, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(434, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(435, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(436, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(437, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(438, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-13'),
(439, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-13'),
(440, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(441, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(442, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-13'),
(443, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(444, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(445, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-13'),
(446, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-13'),
(447, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-13'),
(448, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(449, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(450, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-13'),
(451, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-13'),
(452, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-13'),
(453, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(454, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(455, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-13'),
(456, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-13'),
(457, 8, 4, 'HOME', 'Navigate to HOME', '2025-04-13'),
(458, 8, 4, 'HOME', 'Navigate to HOME', '2025-04-13'),
(459, 8, 4, 'HOME', 'Navigate to HOME', '2025-04-13'),
(460, 8, 4, 'HOME', 'Navigate to HOME', '2025-04-13'),
(461, 8, 4, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(462, 8, 4, 'HOME', 'Navigate to HOME', '2025-04-13'),
(463, 8, 4, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(464, 8, 5, 'HOME', 'Navigate to HOME', '2025-04-13'),
(465, 8, 5, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(466, 8, 5, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(467, 8, 5, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(468, 8, 5, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(469, 8, 5, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(470, 8, 5, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(471, 8, 5, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(472, 8, 4, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(473, 8, 5, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(474, 8, 5, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(475, 8, 4, 'HOME', 'Navigate to HOME', '2025-04-13'),
(476, 8, 5, 'HOME', 'Navigate to HOME', '2025-04-13'),
(477, 8, 5, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(478, 8, 5, 'HOME', 'Navigate to HOME', '2025-04-13'),
(479, 8, 5, 'HOME', 'Navigate to HOME', '2025-04-13'),
(480, 8, 5, 'HOME', 'Navigate to HOME', '2025-04-13'),
(481, 8, 5, 'HOME', 'Navigate to HOME', '2025-04-13'),
(482, 8, 5, 'HOME', 'Navigate to HOME', '2025-04-13'),
(483, 8, 5, 'HOME', 'Navigate to HOME', '2025-04-13'),
(484, 8, 5, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(485, 8, 4, 'HOME', 'Navigate to HOME', '2025-04-13'),
(486, 8, 4, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(487, 8, 4, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(488, 8, 4, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-13'),
(489, 8, 4, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-13'),
(490, 8, 4, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-13'),
(491, 8, 4, 'HOME', 'Navigate to HOME', '2025-04-13'),
(492, 8, 4, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(493, 8, 4, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-13'),
(494, 8, 4, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-13'),
(495, 8, 4, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-13'),
(496, 8, 4, 'HOME', 'Navigate to HOME', '2025-04-13'),
(497, 8, 4, 'HOME', 'Navigate to HOME', '2025-04-13'),
(498, 8, 4, 'HOME', 'Navigate to HOME', '2025-04-13'),
(499, 8, 4, 'HOME', 'Navigate to HOME', '2025-04-13'),
(500, 8, 4, 'HOME', 'Navigate to HOME', '2025-04-13'),
(501, 8, 4, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(502, 8, 4, 'HOME', 'Navigate to HOME', '2025-04-13'),
(503, 8, 4, 'PATIENT', 'Navigate to PATIENT', '2025-04-13'),
(504, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-15'),
(505, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-15'),
(506, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(507, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(508, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(509, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(510, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(511, 1, 6, 'HOME', 'Navigate to HOME', '2025-04-15'),
(512, 1, 6, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(513, 1, 7, 'HOME', 'Navigate to HOME', '2025-04-15'),
(514, 1, 8, 'HOME', 'Navigate to HOME', '2025-04-15'),
(515, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-15'),
(516, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(517, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(518, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-15'),
(519, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(520, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(521, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(522, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-15'),
(523, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(524, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(525, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-15'),
(526, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(527, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(528, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-15'),
(529, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-15'),
(530, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-15'),
(531, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(532, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-15'),
(533, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(534, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-15'),
(535, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-15'),
(536, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(537, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(538, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(539, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-15'),
(540, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(541, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(542, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(543, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(544, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(545, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(546, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(547, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(548, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(549, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-15'),
(550, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(551, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(552, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(553, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(554, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(555, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-15'),
(556, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(557, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(558, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-15'),
(559, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-15'),
(560, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-22'),
(561, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-22'),
(562, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-22'),
(563, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-22'),
(564, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-22'),
(565, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-22'),
(566, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-22'),
(567, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-22'),
(568, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-22'),
(569, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-22'),
(570, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-22'),
(571, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-22'),
(572, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-22'),
(573, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-22'),
(574, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-22'),
(575, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-22'),
(576, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-22'),
(577, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(578, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(579, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-22'),
(580, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(581, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(582, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(583, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(584, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-22'),
(585, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(586, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(587, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-22'),
(588, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(589, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(590, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-22'),
(591, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(592, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-22'),
(593, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(594, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(595, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-22'),
(596, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(597, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(598, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-22'),
(599, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-22'),
(600, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(601, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-22'),
(602, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(603, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-22'),
(604, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(605, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(606, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-22'),
(607, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(608, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-22'),
(609, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-22'),
(610, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-04-22'),
(611, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-23'),
(612, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(613, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-23'),
(614, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(615, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(616, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(617, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(618, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(619, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(620, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(621, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(622, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(623, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(624, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(625, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(626, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(627, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-23'),
(628, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(629, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(630, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(631, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(632, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(633, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(634, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(635, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(636, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(637, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(638, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-23'),
(639, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-23'),
(640, 1, 2, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(641, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(642, 1, 2, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(643, 1, 2, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(644, 1, 2, 'HOME', 'Navigate to HOME', '2025-04-23'),
(645, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-23'),
(646, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-23'),
(647, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-23'),
(648, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-23'),
(649, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-23'),
(650, 1, 3, 'HOME', 'Navigate to HOME', '2025-04-23'),
(651, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(652, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(653, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(654, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(655, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(656, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(657, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(658, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(659, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(660, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(661, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(662, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(663, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(664, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(665, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(666, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(667, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(668, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(669, 1, 3, 'SPECIFICACCOUNTBOOKVIEW', 'Navigate to SPECIFICACCOUNTBOOKVIEW', '2025-04-23'),
(670, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(671, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(672, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(673, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(674, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(675, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(676, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(677, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(678, 1, 3, 'PATIENT', 'Navigate to PATIENT', '2025-04-23'),
(679, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(680, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(681, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23'),
(682, 1, 3, 'SPECIFICACCOUNTBOOK', 'Navigate to SPECIFICACCOUNTBOOK', '2025-04-23');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_account_theme_header`
--

CREATE TABLE `clinic_account_theme_header` (
  `tid` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `themeHeader` varchar(255) NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_account_theme_header`
--

INSERT INTO `clinic_account_theme_header` (`tid`, `account_id`, `themeHeader`, `date_created`) VALUES
(1, 1, 'bg-danger header-text-light', '2025-03-28'),
(2, 8, 'bg-mean-fruit header-text-dark', '2025-04-13');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_account_theme_sidebar`
--

CREATE TABLE `clinic_account_theme_sidebar` (
  `stid` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `theme` varchar(255) NOT NULL,
  `date_create` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_account_theme_sidebar`
--

INSERT INTO `clinic_account_theme_sidebar` (`stid`, `account_id`, `theme`, `date_create`) VALUES
(1, 1, 'bg-primary sidebar-text-light', '2025-03-28'),
(2, 8, 'bg-mean-fruit sidebar-text-dark', '2025-04-13');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_account_type`
--

CREATE TABLE `clinic_account_type` (
  `account_type` int(11) NOT NULL,
  `account` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `amount` double(10,2) NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_account_type`
--

INSERT INTO `clinic_account_type` (`account_type`, `account`, `description`, `amount`, `date_created`) VALUES
(1, 'OCS - PLAN1', 'TEST TEST', 500.00, '2025-03-15'),
(2, 'OCS - PLAN2', 'Lorem ipsum dolor, sit amet consectetur adipisicing elit. Possimus voluptas tempore blanditiis, necessitatibus est accusamus quod numquam quasi laborum iste esse ducimus ratione repudiandae, molestiae autem. Non maiores assumenda minima.', 1000.00, '2025-03-15'),
(3, 'OCS - PLAN3', 'Lorem ipsum dolor, sit amet consectetur adipisicing elit. Possimus voluptas tempore blanditiis, necessitatibus est accusamus quod numquam quasi laborum iste esse ducimus ratione repudiandae, molestiae autem. Non maiores assumenda minima.', 1500.00, '2025-03-15');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_admin`
--

CREATE TABLE `clinic_admin` (
  `admin_id` int(11) NOT NULL,
  `fullname` varchar(50) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `unhashed` varchar(50) NOT NULL,
  `status` varchar(50) DEFAULT 'UNVERIFIED',
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_admin`
--

INSERT INTO `clinic_admin` (`admin_id`, `fullname`, `email`, `phone`, `password`, `unhashed`, `status`, `date_created`) VALUES
(1, 'Erwin Tagulao', 'erwin@gmail.com', '0916653189', '21232f297a57a5a743894a0e4a801fc3', 'admin', 'VERIFIED', '2025-03-30');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_account`
--

CREATE TABLE `clinic_business_account` (
  `account_id` int(11) NOT NULL,
  `business_name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `region` varchar(150) NOT NULL,
  `province` varchar(150) NOT NULL,
  `city` varchar(150) NOT NULL,
  `barangay` varchar(150) NOT NULL,
  `street` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `unhashed` varchar(50) NOT NULL,
  `business_ownership` varchar(50) DEFAULT NULL,
  `business_cert` varchar(255) DEFAULT NULL,
  `business_tin` varchar(255) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'UNVERIFIED',
  `code` int(50) NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_business_account`
--

INSERT INTO `clinic_business_account` (`account_id`, `business_name`, `email`, `phone`, `region`, `province`, `city`, `barangay`, `street`, `password`, `unhashed`, `business_ownership`, `business_cert`, `business_tin`, `status`, `code`, `date_created`) VALUES
(1, 'FamVill', 'familyvilleofficial@gmail.com', '09171439388', 'National Capital Region (NCR)', 'Ncr, Second District', 'Quezon City', 'Santa Lucia', '10 U206 Tarraville Subdivision, Santa Lucia, Novaliches', '21232f297a57a5a743894a0e4a801fc3', 'admin', 'Sole Proprietor', 'uploads/1742302421_1742035607_BSIS4E-GROUP3_ACM_FORMAT.docx', '11111111', 'SUBSCRIBED', 6690, '2025-03-18'),
(10, 'Arron CO.', 'jhayarronjoaquin02@gmail.com', '09786756241', 'Region IV-A (CALABARZON)', 'Cavite', 'Mendez (Mendez-nuñez)', 'Banayad', 'garden', '21232f297a57a5a743894a0e4a801fc3', 'admin', 'Sole Proprietor', 'uploads/1745328603_RobloxScreenShot20240726_203819092.png', '1234', 'SUBSCRIBED', 9647, '2025-04-22'),
(11, 'kushi', 'kushihsimoto02@gmail.com', '09768412345', 'Autonomous Region in Muslim Mindanao (ARMM)', 'Basilan', 'Tuburan', 'Sinulatan', 'qwes', '21232f297a57a5a743894a0e4a801fc3', 'admin', 'Sole Proprietor', 'uploads/1745342332_RobloxScreenShot20240729_105709596.png', '4321', 'VERIFIED', 8807, '2025-04-23');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_account_announcement`
--

CREATE TABLE `clinic_business_account_announcement` (
  `announcement_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `announcement_title` varchar(50) NOT NULL,
  `announcement_content` text NOT NULL,
  `status` varchar(50) NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_business_account_announcement`
--

INSERT INTO `clinic_business_account_announcement` (`announcement_id`, `account_id`, `announcement_title`, `announcement_content`, `status`, `date_created`) VALUES
(1, 1, 'holy week', 'TEST', 'ACTIVE', '2025-03-29'),
(2, 8, 'test', 'test', 'IN-ACTIVE', '2025-04-13'),
(3, 8, 'nice', 'nice', 'ACTIVE', '2025-04-13');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_account_appointment`
--

CREATE TABLE `clinic_business_account_appointment` (
  `aid` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `pid` varchar(50) NOT NULL,
  `uid` int(10) NOT NULL,
  `date_birth` date NOT NULL,
  `age` int(10) NOT NULL,
  `fullname` varchar(100) NOT NULL,
  `purpose` varchar(100) NOT NULL,
  `purpose_description` text NOT NULL,
  `gender` varchar(50) NOT NULL,
  `schedule_date` date NOT NULL,
  `status` varchar(50) NOT NULL,
  `fromIns` varchar(50) NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_business_account_appointment`
--

INSERT INTO `clinic_business_account_appointment` (`aid`, `account_id`, `pid`, `uid`, `date_birth`, `age`, `fullname`, `purpose`, `purpose_description`, `gender`, `schedule_date`, `status`, `fromIns`, `date_created`) VALUES
(1, 1, '250318-81881', 1, '2020-06-02', 4, 'Erwin Son', '2 ', 'TEST', 'MALE', '2025-03-18', 'COMPLETED', 'WEB', '2025-03-28'),
(2, 1, '250328-83764', 1, '2022-02-28', 3, 'Gerald Mico', '3 ', 'Shit happens', 'FEMALE', '2025-03-28', 'PAYED CONFIRM', 'WEB', '2025-03-28'),
(4, 1, '250328-95475', 1, '2019-06-04', 5, 'Gerald Mico', '2 ', 'PEDIATRIC TEST', 'MALE', '2025-03-31', 'BOOKED', 'WEB', '2025-03-29'),
(5, 1, '250328-76822', 1, '2019-06-04', 5, 'Jerwin', '2 ', 'PEDIATRIC TEST1', 'MALE', '2025-03-31', 'PAYED CONFIRM', 'WEB', '2025-03-29'),
(6, 1, '250329-73125', 3, '2022-02-01', 3, 'Gerald Mico Baby', '2 ', 'CUTIE', 'MALE', '2025-03-31', 'BOOKED', 'WEB', '2025-03-29'),
(7, 1, '250330-68633', 3, '2019-06-30', 5, 'Erwin Tags', '2 ', 'SAKIT SA HININGA', 'FEMALE', '2025-03-31', 'PAYED CONFIRM', 'WEB', '2025-03-30'),
(8, 1, '250330-90603', 3, '2016-06-30', 8, 'Erwin I', '5 ', 'TEST', 'MALE', '2025-03-30', 'CONFIRMED', 'WEB', '2025-03-30'),
(9, 1, '250412-69423', 1, '2021-06-13', 3, 'Johny Part1', '2 ', 'TEST', 'MALE', '2025-04-14', 'BOOKED', 'WEB', '2025-04-12'),
(10, 1, '250412-67459', 1, '2025-04-12', 0, 'Gerald Mico', '2 ', 'TEST', 'MALE', '2025-04-14', 'BOOKED', 'WEB', '2025-04-12'),
(11, 1, '250413-66796', 1, '2022-01-13', 3, 'EST', '2 ', 'test', 'MALE', '0000-00-00', 'BOOKED', 'WEB', '2025-04-13'),
(12, 1, '250413-90491', 1, '2025-04-13', 0, 'Gerald Mico est', '2 ', 'TEST', 'MALE', '2025-04-13', 'BOOKED', 'WEB', '2025-04-13'),
(13, 1, '250413-68704', 1, '2025-04-14', 0, 'Gerald Mico 1', '2 ', 'test', 'MALE', '2025-04-13', 'PAYED CONFIRM', 'WEB', '2025-04-13'),
(14, 1, '250413-88020', 1, '2025-04-13', 0, 'Gerald Mico 2', '3 ', 'TEST', 'MALE', '2025-04-14', 'BOOKED', 'WEB', '2025-04-13'),
(15, 1, '250412-69096', 1, '2025-04-12', 0, 'Celeste 1', '2 ', 'TEST', 'MALE', '2025-04-12', 'PAYED PENDING', 'WEB', '2025-04-13'),
(16, 1, '250412-85205', 1, '2025-04-11', 0, 'Celetes 2', '3 ', 'TEST', 'MALE', '2025-04-15', 'BOOKED', 'WEB', '2025-04-13'),
(17, 1, '250412-96235', 1, '2025-04-11', 0, 'Gerald Mico Check Today', '2 ', 'TEST', 'MALE', '2025-04-13', 'CONFIRMED', 'WEB', '2025-04-13'),
(18, 1, '250413-69355', 1, '2025-04-13', 0, 'Body Parts 1', '2 ', 'TEST', 'MALE', '2025-04-13', 'PAYED CONFIRM', 'WEB', '2025-04-13'),
(19, 1, '250413-79330', 1, '2025-04-13', 0, 'Body Parts 2', '3 ', 'test', 'MALE', '2025-04-15', 'PAYED CONFIRM', 'WEB', '2025-04-13'),
(20, 1, '250413-98974', 3, '2025-04-13', 0, 'Gerald Mico 1', '2 ', 'TREST', 'MALE', '2025-04-13', 'PAYED PENDING', 'WEB', '2025-04-13'),
(21, 1, '250413-94902', 3, '2025-04-13', 0, 'Gerald Mico 2', '2 ', 'test', 'MALE', '2025-04-14', 'BOOKED', 'WEB', '2025-04-13'),
(22, 8, '250413-76737', 6, '2025-04-13', 0, 'nora', '7 ', 'test', 'MALE', '2025-04-13', 'PAYED PENDING', 'WEB', '2025-04-13'),
(23, 8, '250413-86199', 6, '2025-04-10', 0, 'nnn', '7 ', 'tewst', 'MALE', '2025-04-14', 'CONFIRMED', 'WEB', '2025-04-13'),
(24, 8, '250413-92446', 6, '2025-04-01', 0, 'erib', '7 ', 'test', 'FEMALE', '2025-04-13', 'PAYED CONFIRM', 'WEB', '2025-04-13'),
(25, 1, '250415-70272', 5, '2025-04-15', 0, 'eee', '2 ', 'teest', 'MALE', '2025-04-16', 'BOOKED', 'WEB', '2025-04-15'),
(26, 1, '250415-96024', 5, '2025-04-25', 0, 'www', '2 ', 'test', 'MALE', '2025-04-16', 'BOOKED', 'WEB', '2025-04-15'),
(27, 10, '250422-97028', 10, '2025-03-31', 0, 'nora', '8 ', 'test', 'MALE', '2025-04-22', 'PAYED CONFIRM', 'WEB', '2025-04-22'),
(28, 10, '250422-91534', 11, '2025-03-31', 0, 'arrib daughter', '8 ', 'test', 'FEMALE', '2025-04-22', 'PAYED PENDING', 'WEB', '2025-04-22'),
(29, 1, '250422-79707', 9, '2025-03-31', 0, 'son', '2 ', 'test', 'MALE', '2025-04-22', 'PAYED CONFIRM', 'WEB', '2025-04-22'),
(30, 1, '250422-85485', 5, '2025-04-06', 0, 'aron1son', '2 ', 'test', 'MALE', '2025-04-23', 'CANCELLED', 'WEB', '2025-04-22'),
(31, 1, '250422-68443', 5, '2025-04-06', 0, 'aron1son', '2 ', 'test', 'MALE', '2025-04-26', 'BOOKED', 'WEB', '2025-04-22');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_account_appointment_follow_up`
--

CREATE TABLE `clinic_business_account_appointment_follow_up` (
  `fid` int(11) NOT NULL,
  `aid` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `schedule_date` date NOT NULL,
  `diagnosis` text DEFAULT NULL,
  `status` varchar(50) DEFAULT 'BOOKED',
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_business_account_appointment_follow_up`
--

INSERT INTO `clinic_business_account_appointment_follow_up` (`fid`, `aid`, `account_id`, `doctor_id`, `schedule_date`, `diagnosis`, `status`, `date_created`) VALUES
(1, 6, 1, 2, '2025-03-30', 'jUST KIDDING', 'CONFIRMED', '2025-03-29'),
(2, 6, 1, 2, '2025-08-28', 'really kidding', 'CANCELLED', '2025-03-30'),
(3, 24, 8, 4, '2025-04-22', NULL, 'BOOKED', '2025-04-13'),
(4, 13, 1, 3, '2025-04-24', NULL, 'BOOKED', '2025-04-23'),
(5, 30, 1, 3, '2025-04-25', NULL, 'BOOKED', '2025-04-23');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_account_inquiry`
--

CREATE TABLE `clinic_business_account_inquiry` (
  `bid` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `subject` varchar(50) NOT NULL,
  `message` text DEFAULT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_business_account_inquiry`
--

INSERT INTO `clinic_business_account_inquiry` (`bid`, `account_id`, `name`, `email`, `subject`, `message`, `date_created`) VALUES
(1, 1, 'Gerald Mico', 'gmfacistol@outlook.com', 'PRICING', 'TEST', '2025-04-04'),
(2, 8, 'test', 'test@gmail.com', 'admin', 'asdadfaf', '2025-04-13');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_account_patient`
--

CREATE TABLE `clinic_business_account_patient` (
  `client_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `fullname` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `unhashed` varchar(50) NOT NULL,
  `status` varchar(50) DEFAULT 'UNVERIFIED',
  `code` int(50) NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_business_account_patient`
--

INSERT INTO `clinic_business_account_patient` (`client_id`, `account_id`, `fullname`, `username`, `email`, `phone`, `password`, `unhashed`, `status`, `code`, `date_created`) VALUES
(1, 1, 'Jerwin Tagulao', 'Jerwin012', 'jerwin@outlook.com', '09531599179', '098f6bcd4621d373cade4e832627b4f6', 'test', 'VERIFIED', 859679, '2025-03-18'),
(5, 1, 'Arron Test', 'Aron1', 'gmfacistol@outlook.com', '0916653178', '21232f297a57a5a743894a0e4a801fc3', 'admin', 'VERIFIED', 998393, '2025-03-30'),
(6, 8, 'Jhay Arron', 'jhay', 'jhay@gmail.com', '09897682312', '21232f297a57a5a743894a0e4a801fc3', 'admin', 'VERIFIED', 846751, '2025-04-13'),
(7, 8, 'joshua', 'jjosh', 'josh@gmail.com', '092387562389746127846128', '21232f297a57a5a743894a0e4a801fc3', 'admin', 'UNVERIFIED', 928772, '2025-04-15'),
(8, 1, 'err', 'err', 'err@gmail.com', '09128974612398763875632', '21232f297a57a5a743894a0e4a801fc3', 'admin', 'VERIFIED', 688125, '2025-04-15'),
(9, 1, 'rown jhay', 'rown', 'rown@gmail.com', '09675642314', '21232f297a57a5a743894a0e4a801fc3', 'admin', 'VERIFIED', 896876, '2025-04-22'),
(11, 10, 'ARRIB', 'arrib', 'arrib@gmail.com', '0978676421', '21232f297a57a5a743894a0e4a801fc3', 'admin', 'VERIFIED', 730436, '2025-04-22');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_account_paymentintegration`
--

CREATE TABLE `clinic_business_account_paymentintegration` (
  `pid` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `public_key` varchar(255) NOT NULL,
  `secret_key` varchar(255) NOT NULL,
  `status` varchar(50) NOT NULL,
  `mode` varchar(50) NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_business_account_paymentintegration`
--

INSERT INTO `clinic_business_account_paymentintegration` (`pid`, `account_id`, `public_key`, `secret_key`, `status`, `mode`, `date_created`) VALUES
(1, 1, 'pk_test_9srNwze4WeVdFhYzBdzDTN6W', 'sk_test_w2jX6orfaJGqCeDMXsHqA2SD', 'Active', 'Testing', '2025-03-18'),
(3, 8, 'pk_test_9srNwze4WeVdFhYzBdzDTN6W', 'sk_test_w2jX6orfaJGqCeDMXsHqA2SD', 'Active', 'Testing', '2025-04-13'),
(5, 10, 'pk_test_9srNwze4WeVdFhYzBdzDTN6W', 'sk_test_w2jX6orfaJGqCeDMXsHqA2SD', 'Active', 'Testing', '2025-04-22');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_account_subscription`
--

CREATE TABLE `clinic_business_account_subscription` (
  `subs_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `paymethod` varchar(50) NOT NULL,
  `trans_id` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `code` varchar(50) NOT NULL,
  `account_type` int(11) NOT NULL,
  `status` varchar(50) DEFAULT 'PENDING',
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_business_account_subscription`
--

INSERT INTO `clinic_business_account_subscription` (`subs_id`, `account_id`, `paymethod`, `trans_id`, `email`, `code`, `account_type`, `status`, `date_created`) VALUES
(1, 1, 'grabpay', 'src_RsZmDqiXnMwCvs4zKvWnrZgw', 'familyvilleofficial@gmail.com', '7056', 3, 'PAYED', '2025-03-18'),
(2, 1, 'gcash', 'src_ZAHTaMrcZHrpowJMGnQPaQPN', 'familyvilleofficial@gmail.com', '7700', 3, 'PENDING', '2025-03-20'),
(3, 5, 'gcash', 'src_ZcgtM2gkY31DiPvgfCYiV4U9', 'gmfacistol@outlook.com', '7125', 2, 'PAYED', '2025-04-13'),
(4, 6, 'gcash', 'src_biUHXNc1Yx381sELhtTZcriF', 'reactgaming012@gmail.com', '7422', 3, 'PAYED', '2025-04-13'),
(5, 8, 'gcash', 'src_dS8i8dnaDy9mbmAbwHMw71TU', 'jhayarronjoaquin02@gmail.com', '7875', 1, 'PAYED', '2025-04-13'),
(6, 10, 'gcash', 'src_zKbrBtDmvnC2AtvRyGK25BjC', 'jhayarronjoaquin02@gmail.com', '9591', 3, 'PAYED', '2025-04-22');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_appointment_feedback`
--

CREATE TABLE `clinic_business_appointment_feedback` (
  `feedid` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `pid` varchar(150) NOT NULL,
  `rate` varchar(10) NOT NULL,
  `feedback` varchar(255) NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_business_appointment_feedback`
--

INSERT INTO `clinic_business_appointment_feedback` (`feedid`, `account_id`, `client_id`, `pid`, `rate`, `feedback`, `date_created`) VALUES
(1, 1, 1, '250318-81881 ', '3', 'NOT SO GOOD', '2025-03-29'),
(2, 1, 3, '250329-73125 ', '5', 'baho tlaga nang hininga nung doctor', '2025-03-30'),
(3, 1, 1, '250318-81881', '2', 'TEST', '2025-04-13'),
(4, 1, 1, '250328-83764', '2', 'test', '2025-04-13'),
(5, 8, 6, '250413-92446', '3', 'nice', '2025-04-13'),
(6, 1, 5, '250422-85485', '5', 'good service', '2025-04-22');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_assigned_doctor_appointment`
--

CREATE TABLE `clinic_business_assigned_doctor_appointment` (
  `docapt` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `aid` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `diagnosis` text DEFAULT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_business_assigned_doctor_appointment`
--

INSERT INTO `clinic_business_assigned_doctor_appointment` (`docapt`, `account_id`, `aid`, `user_id`, `diagnosis`, `date_created`) VALUES
(1, 1, 1, 2, 'Just a test', '2025-03-28'),
(2, 1, 2, 2, NULL, '2025-03-28'),
(3, 1, 5, 2, NULL, '2025-03-29'),
(4, 1, 4, 2, NULL, '2025-03-29'),
(5, 1, 6, 2, 'SHORTEN HEAD', '2025-03-29'),
(6, 1, 7, 2, NULL, '2025-03-30'),
(7, 1, 8, 2, NULL, '2025-03-30'),
(8, 1, 11, 2, NULL, '2025-04-13'),
(9, 1, 12, 2, NULL, '2025-04-13'),
(10, 1, 13, 2, NULL, '2025-04-13'),
(11, 1, 15, 2, NULL, '2025-04-13'),
(12, 1, 17, 2, NULL, '2025-04-13'),
(13, 1, 18, 2, NULL, '2025-04-13'),
(14, 1, 19, 2, NULL, '2025-04-13'),
(15, 1, 20, 2, NULL, '2025-04-13'),
(16, 8, 22, 4, NULL, '2025-04-13'),
(17, 8, 23, 4, NULL, '2025-04-13'),
(18, 8, 24, 4, 'sipon', '2025-04-13'),
(19, 10, 27, 10, NULL, '2025-04-22'),
(20, 10, 28, 10, NULL, '2025-04-22'),
(21, 1, 29, 2, NULL, '2025-04-22'),
(22, 1, 30, 2, NULL, '2025-04-22');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_main_paymongo_configuration`
--

CREATE TABLE `clinic_business_main_paymongo_configuration` (
  `config_id` int(11) NOT NULL,
  `pk_id` varchar(255) NOT NULL,
  `sk_id` varchar(255) NOT NULL,
  `status` varchar(50) DEFAULT 'ACTIVE',
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_business_main_paymongo_configuration`
--

INSERT INTO `clinic_business_main_paymongo_configuration` (`config_id`, `pk_id`, `sk_id`, `status`, `date_created`) VALUES
(1, 'pk_test_9srNwze4WeVdFhYzBdzDTN6W', 'sk_test_w2jX6orfaJGqCeDMXsHqA2SD', 'ACTIVE', '2025-03-18');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_my_appointment_payment`
--

CREATE TABLE `clinic_business_my_appointment_payment` (
  `payid` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `aid` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `method` varchar(50) NOT NULL,
  `trans_id` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_business_my_appointment_payment`
--

INSERT INTO `clinic_business_my_appointment_payment` (`payid`, `account_id`, `aid`, `client_id`, `method`, `trans_id`, `url`, `code`, `email`, `date_created`) VALUES
(1, 1, 1, 1, 'gcash', 'src_esujvBjsVqNFPfrMdNDNRNHx', 'https://test-sources.paymongo.com/sources?id=src_AKmkb74enYgL6ZarqdcPmRfp', '9470', 'jerwin@outlook.com', '2025-03-28'),
(2, 1, 1, 1, 'gcash', 'src_esujvBjsVqNFPfrMdNDNRNHx', 'https://test-sources.paymongo.com/sources?id=src_AKmkb74enYgL6ZarqdcPmRfp', '9470', 'jerwin@outlook.com', '2025-03-28'),
(3, 1, 1, 1, 'grabpay', 'src_B7ZYtg1eEuTJ5ZvLETu6188N', 'https://test-sources.paymongo.com/sources?id=src_bYCJE1SVFCQxZdsP2eDboaxs', '9463', 'jerwin@outlook.com', '2025-03-28'),
(4, 1, 2, 1, 'grabpay', 'src_UYinWugCHhthtT2NawST7GSj', 'https://test-sources.paymongo.com/sources?id=src_D1EVKhvHApGQXCFjCyVVaFZs', '7490', 'jerwin@outlook.com', '2025-03-28'),
(5, 1, 5, 1, 'gcash', 'src_fS78Y16ULg5ncyKEiMJMSpDs', 'https://test-sources.paymongo.com/sources?id=src_CmVWWtA1k6M9FVniMqQu7atJ', '9663', 'jerwin@outlook.com', '2025-03-29'),
(6, 1, 5, 1, 'gcash', 'src_tbRhJw6acMnTxN7cKroqUZvq', 'https://test-sources.paymongo.com/sources?id=src_5ndf6WwsG4Kqd9FDPyxQ5PXc', '7903', 'jerwin@outlook.com', '2025-03-29'),
(7, 1, 5, 1, 'grabpay', 'src_11Sf9vXW2V32SADBAyukqLKf', 'https://test-sources.paymongo.com/sources?id=src_gPJTnMw5W8JCcQ4HS9Bk9PcA', '8320', 'jerwin@outlook.com', '2025-03-29'),
(8, 1, 5, 1, 'grabpay', 'src_11Sf9vXW2V32SADBAyukqLKf', 'https://test-sources.paymongo.com/sources?id=src_gPJTnMw5W8JCcQ4HS9Bk9PcA', '8320', 'jerwin@outlook.com', '2025-03-29'),
(9, 1, 5, 1, 'gcash', 'src_jnxM9vTGN8iKWoDrcHuLe7xx', 'https://test-sources.paymongo.com/sources?id=src_Zjzc4m8g8yKcf1uP17BRwknb', '9142', 'jerwin@outlook.com', '2025-03-29'),
(10, 1, 7, 3, 'grabpay', 'src_RcLHhXay7JCjfZAkFYfbxJYy', 'https://test-sources.paymongo.com/sources?id=src_StcFpGmc1BoCNXSVjJjpDfQr', '6824', 'revcoreitsolutions@gmail.com', '2025-03-30'),
(11, 1, 7, 3, 'grabpay', 'src_RcLHhXay7JCjfZAkFYfbxJYy', 'https://test-sources.paymongo.com/sources?id=src_StcFpGmc1BoCNXSVjJjpDfQr', '6824', 'revcoreitsolutions@gmail.com', '2025-03-30'),
(12, 1, 13, 1, 'cash_payment', '0', '0', '7680', 'jerwin@outlook.com', '2025-04-13'),
(13, 1, 13, 1, 'cash_payment', '0', '0', '7756', 'jerwin@outlook.com', '2025-04-13'),
(14, 1, 13, 1, 'cash_payment', '0', '0', '7862', 'jerwin@outlook.com', '2025-04-13'),
(15, 1, 13, 1, 'cash_payment', '0', '0', '7959', 'jerwin@outlook.com', '2025-04-13'),
(16, 1, 5, 1, 'cash_payment', '0', '0', '6705', 'jerwin@outlook.com', '2025-04-13'),
(17, 1, 18, 1, 'cash_payment', '0', '0', '8573', 'jerwin@outlook.com', '2025-04-13'),
(18, 1, 19, 1, 'cash_payment', '0', '0', '9569', 'jerwin@outlook.com', '2025-04-13'),
(19, 1, 15, 1, 'gcash', 'src_PKg1swXNqKs5kJWMfkBdvHTL', 'https://test-sources.paymongo.com/sources?id=src_y7nU73Hey5VP3umVHPvMG9r2', '8549', 'jerwin@outlook.com', '2025-04-13'),
(20, 1, 20, 3, 'gcash', 'src_orbX9A6TzqajY5WVuY8PJQZu', 'https://test-sources.paymongo.com/sources?id=src_orbX9A6TzqajY5WVuY8PJQZu', '9160', 'gmfacistol@outlook.com', '2025-04-13'),
(21, 1, 20, 3, 'gcash', 'src_orbX9A6TzqajY5WVuY8PJQZu', 'https://test-sources.paymongo.com/sources?id=src_orbX9A6TzqajY5WVuY8PJQZu', '9160', 'gmfacistol@outlook.com', '2025-04-13'),
(22, 8, 22, 6, 'gcash', 'src_um7vDiTjhQ5NyXKEWZyqyMFV', 'https://test-sources.paymongo.com/sources?id=src_um7vDiTjhQ5NyXKEWZyqyMFV', '9805', 'jhay@gmail.com', '2025-04-13'),
(23, 8, 24, 6, 'cash_payment', '0', '0', '7245', 'jhay@gmail.com', '2025-04-13'),
(24, 10, 27, 10, 'cash_payment', '0', '0', '7704', 'jhayarron@gmail.com', '2025-04-22'),
(25, 10, 28, 11, 'gcash', 'src_K4deAYKeJAaKjiUP7fvwyWcQ', 'https://test-sources.paymongo.com/sources?id=src_K4deAYKeJAaKjiUP7fvwyWcQ', '7093', 'arrib@gmail.com', '2025-04-22'),
(26, 1, 29, 9, 'cash_payment', '0', '0', '8216', 'rown@gmail.com', '2025-04-22'),
(27, 1, 29, 9, 'gcash', 'src_Q68phRpZP8skm8NPv51M6p1x', 'https://test-sources.paymongo.com/sources?id=src_Q68phRpZP8skm8NPv51M6p1x', '6995', 'rown@gmail.com', '2025-04-22'),
(28, 1, 29, 9, 'cash_payment', '0', '0', '9485', 'rown@gmail.com', '2025-04-22');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_roles`
--

CREATE TABLE `clinic_business_roles` (
  `role_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `role_name` varchar(50) NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_business_roles`
--

INSERT INTO `clinic_business_roles` (`role_id`, `account_id`, `role_name`, `date_created`) VALUES
(12, 1, 'DOCTOR', '2025-04-15'),
(15, 1, 'ASSISTANT DOCTOR', '2025-04-15'),
(16, 10, 'DOCTOR', '2025-04-22'),
(18, 1, 'DOCTOR ASSISTANT', '2025-04-22'),
(19, 1, 'dr', '2025-04-23'),
(20, 1, 'dra', '2025-04-23');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_service`
--

CREATE TABLE `clinic_business_service` (
  `bsid` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `service` varchar(50) NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_business_service`
--

INSERT INTO `clinic_business_service` (`bsid`, `account_id`, `service`, `date_created`) VALUES
(2, 1, 'PEDIATRIC', '2025-03-18'),
(3, 1, 'ORTHOPHEDIC', '2025-03-18'),
(5, 1, 'ERWIN UPDATE', '2025-03-30'),
(7, 8, 'CHECKUP', '2025-04-13'),
(8, 10, 'CHECKUP', '2025-04-22'),
(9, 10, 'VACCINATION', '2025-04-22');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_service_account`
--

CREATE TABLE `clinic_business_service_account` (
  `sid` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_business_service_account`
--

INSERT INTO `clinic_business_service_account` (`sid`, `account_id`, `role_id`, `date_created`) VALUES
(2, 1, 1, '2025-03-28'),
(5, 5, 4, '2025-04-13'),
(6, 8, 6, '2025-04-13'),
(7, 1, 13, '2025-04-15'),
(8, 1, 12, '2025-04-15'),
(9, 1, 14, '2025-04-15'),
(10, 1, 15, '2025-04-15'),
(11, 10, 16, '2025-04-22');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_service_ticket`
--

CREATE TABLE `clinic_business_service_ticket` (
  `ticketid` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `subject` varchar(50) NOT NULL,
  `concern` text NOT NULL,
  `status` varchar(50) DEFAULT 'SUBMITTED',
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_business_service_ticket`
--

INSERT INTO `clinic_business_service_ticket` (`ticketid`, `account_id`, `level`, `subject`, `concern`, `status`, `date_created`) VALUES
(2, 1, 5, 'TEST', 'TEST', 'COMPLETED', '2025-03-30'),
(3, 1, 4, 'test', 'test', 'SUBMITTED', '2025-03-30'),
(4, 10, 1, 'error', 'sira yung login', 'COMPLETED', '2025-04-22');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_service_ticket_response`
--

CREATE TABLE `clinic_business_service_ticket_response` (
  `response_id` int(11) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `response` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_business_service_ticket_response`
--

INSERT INTO `clinic_business_service_ticket_response` (`response_id`, `ticket_id`, `response`) VALUES
(1, 3, 'THIS IS A SHIT'),
(2, 3, 'CHECK\r\n'),
(3, 3, 'SUPPORT TESTING CURRENTLY '),
(4, 2, 'gago kaba pangalawang beses na yan'),
(5, 2, 'Fuck you'),
(6, 3, 'ok');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_bussiness_account_users`
--

CREATE TABLE `clinic_bussiness_account_users` (
  `user_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `fullname` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `unhashed` varchar(50) NOT NULL,
  `role` int(11) NOT NULL,
  `status` varchar(50) DEFAULT 'UNVERIFIED',
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_bussiness_account_users`
--

INSERT INTO `clinic_bussiness_account_users` (`user_id`, `account_id`, `fullname`, `email`, `phone`, `password`, `unhashed`, `role`, `status`, `date_created`) VALUES
(2, 1, 'jer', 'jer@gmail.com', '09171439388', '21232f297a57a5a743894a0e4a801fc3', 'admin', 12, 'VERIFIED', '2025-03-28'),
(3, 1, 'Erwin', 'erwin@gmail.com', '09888888888', '785f0b13d4daf8eee0d11195f58302a4', 'erwin', 18, 'VERIFIED', '2025-03-30'),
(4, 8, 'VIR', 'vir@gmail.com', '09998787642', '21232f297a57a5a743894a0e4a801fc3', 'admin', 6, 'VERIFIED', '2025-04-13'),
(5, 8, 'joaquin', 'joaquin@gmail.com', '09786452132', '21232f297a57a5a743894a0e4a801fc3', 'admin', 7, 'VERIFIED', '2025-04-13'),
(6, 1, 'test', 'testing@gmail.com', '0988742124', '21232f297a57a5a743894a0e4a801fc3', 'admin', 8, 'VERIFIED', '2025-04-15'),
(7, 1, 'docas', 'docas@gmail.com', '0987876421', '21232f297a57a5a743894a0e4a801fc3', 'admin', 9, 'VERIFIED', '2025-04-15'),
(8, 1, 'doctors', 'doctors@gmail.com', '09786784212', '21232f297a57a5a743894a0e4a801fc3', 'admin', 11, 'VERIFIED', '2025-04-15'),
(9, 10, 'vir', 'virhenrickmalate9@gmail.com', '09786731241', '21232f297a57a5a743894a0e4a801fc3', 'admin', 17, 'VERIFIED', '2025-04-22'),
(10, 10, 'erwin tagulao', 'tagulaoerwin@gmail.com', '09786731523', '21232f297a57a5a743894a0e4a801fc3', 'admin', 16, 'VERIFIED', '2025-04-22');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_bussiness_account_users_paygrade`
--

CREATE TABLE `clinic_bussiness_account_users_paygrade` (
  `paygradeid` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `paygrade` double(10,2) NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_bussiness_account_users_paygrade`
--

INSERT INTO `clinic_bussiness_account_users_paygrade` (`paygradeid`, `user_id`, `account_id`, `paygrade`, `date_created`) VALUES
(1, 2, 1, 600.00, '2025-03-28'),
(2, 3, 1, 550.00, '2025-03-30'),
(3, 4, 8, 600.00, '2025-04-13'),
(4, 5, 8, 750.00, '2025-04-13'),
(5, 9, 10, 700.00, '2025-04-22'),
(6, 10, 10, 800.00, '2025-04-22'),
(7, 11, 10, 1000.00, '2025-04-22');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_main_faq`
--

CREATE TABLE `clinic_main_faq` (
  `faq_id` int(11) NOT NULL,
  `faq_title` varchar(50) NOT NULL,
  `faq_answer` text NOT NULL,
  `created_date` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_main_faq`
--

INSERT INTO `clinic_main_faq` (`faq_id`, `faq_title`, `faq_answer`, `created_date`) VALUES
(1, 'Why does my pediatric clinic need a website?', 'Having a website helps your clinic establish trust with parents looking for reliable healthcare providers. It makes your clinic easier to find online, provides important information like clinic hours and contact details, and offers a convenient way for patients to get in touch or book appointments.', '2025-03-16'),
(2, 'How can a website help my pediatric clinic grow?', 'A website can attract new families by improving your clinic’s online visibility and making it easier for parents to learn about your services. It also strengthens your clinic’s credibility and allows you to communicate updates, promotions, or health tips to your patients more effectively.\n\n', '2025-03-16');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_main_inquiry`
--

CREATE TABLE `clinic_main_inquiry` (
  `inq_id` int(11) NOT NULL,
  `fullname` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `subject` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `clinic_account_cart`
--
ALTER TABLE `clinic_account_cart`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `clinic_account_order`
--
ALTER TABLE `clinic_account_order`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `clinic_account_order_item`
--
ALTER TABLE `clinic_account_order_item`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `clinic_account_owner_history`
--
ALTER TABLE `clinic_account_owner_history`
  ADD PRIMARY KEY (`actid`);

--
-- Indexes for table `clinic_account_patient_history`
--
ALTER TABLE `clinic_account_patient_history`
  ADD PRIMARY KEY (`actid`);

--
-- Indexes for table `clinic_account_payment`
--
ALTER TABLE `clinic_account_payment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `clinic_account_product`
--
ALTER TABLE `clinic_account_product`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_code` (`code`);

--
-- Indexes for table `clinic_account_staff_history`
--
ALTER TABLE `clinic_account_staff_history`
  ADD PRIMARY KEY (`actid`);

--
-- Indexes for table `clinic_account_theme_header`
--
ALTER TABLE `clinic_account_theme_header`
  ADD PRIMARY KEY (`tid`);

--
-- Indexes for table `clinic_account_theme_sidebar`
--
ALTER TABLE `clinic_account_theme_sidebar`
  ADD PRIMARY KEY (`stid`);

--
-- Indexes for table `clinic_account_type`
--
ALTER TABLE `clinic_account_type`
  ADD PRIMARY KEY (`account_type`);

--
-- Indexes for table `clinic_admin`
--
ALTER TABLE `clinic_admin`
  ADD PRIMARY KEY (`admin_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone` (`phone`);

--
-- Indexes for table `clinic_business_account`
--
ALTER TABLE `clinic_business_account`
  ADD PRIMARY KEY (`account_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone` (`phone`);

--
-- Indexes for table `clinic_business_account_announcement`
--
ALTER TABLE `clinic_business_account_announcement`
  ADD PRIMARY KEY (`announcement_id`);

--
-- Indexes for table `clinic_business_account_appointment`
--
ALTER TABLE `clinic_business_account_appointment`
  ADD PRIMARY KEY (`aid`);

--
-- Indexes for table `clinic_business_account_appointment_follow_up`
--
ALTER TABLE `clinic_business_account_appointment_follow_up`
  ADD PRIMARY KEY (`fid`);

--
-- Indexes for table `clinic_business_account_inquiry`
--
ALTER TABLE `clinic_business_account_inquiry`
  ADD PRIMARY KEY (`bid`);

--
-- Indexes for table `clinic_business_account_patient`
--
ALTER TABLE `clinic_business_account_patient`
  ADD PRIMARY KEY (`client_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone` (`phone`);

--
-- Indexes for table `clinic_business_account_paymentintegration`
--
ALTER TABLE `clinic_business_account_paymentintegration`
  ADD PRIMARY KEY (`pid`);

--
-- Indexes for table `clinic_business_account_subscription`
--
ALTER TABLE `clinic_business_account_subscription`
  ADD PRIMARY KEY (`subs_id`);

--
-- Indexes for table `clinic_business_appointment_feedback`
--
ALTER TABLE `clinic_business_appointment_feedback`
  ADD PRIMARY KEY (`feedid`);

--
-- Indexes for table `clinic_business_assigned_doctor_appointment`
--
ALTER TABLE `clinic_business_assigned_doctor_appointment`
  ADD PRIMARY KEY (`docapt`);

--
-- Indexes for table `clinic_business_main_paymongo_configuration`
--
ALTER TABLE `clinic_business_main_paymongo_configuration`
  ADD PRIMARY KEY (`config_id`);

--
-- Indexes for table `clinic_business_my_appointment_payment`
--
ALTER TABLE `clinic_business_my_appointment_payment`
  ADD PRIMARY KEY (`payid`);

--
-- Indexes for table `clinic_business_roles`
--
ALTER TABLE `clinic_business_roles`
  ADD PRIMARY KEY (`role_id`);

--
-- Indexes for table `clinic_business_service`
--
ALTER TABLE `clinic_business_service`
  ADD PRIMARY KEY (`bsid`);

--
-- Indexes for table `clinic_business_service_account`
--
ALTER TABLE `clinic_business_service_account`
  ADD PRIMARY KEY (`sid`);

--
-- Indexes for table `clinic_business_service_ticket`
--
ALTER TABLE `clinic_business_service_ticket`
  ADD PRIMARY KEY (`ticketid`);

--
-- Indexes for table `clinic_business_service_ticket_response`
--
ALTER TABLE `clinic_business_service_ticket_response`
  ADD PRIMARY KEY (`response_id`);

--
-- Indexes for table `clinic_bussiness_account_users`
--
ALTER TABLE `clinic_bussiness_account_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone` (`phone`);

--
-- Indexes for table `clinic_bussiness_account_users_paygrade`
--
ALTER TABLE `clinic_bussiness_account_users_paygrade`
  ADD PRIMARY KEY (`paygradeid`);

--
-- Indexes for table `clinic_main_faq`
--
ALTER TABLE `clinic_main_faq`
  ADD PRIMARY KEY (`faq_id`);

--
-- Indexes for table `clinic_main_inquiry`
--
ALTER TABLE `clinic_main_inquiry`
  ADD PRIMARY KEY (`inq_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `clinic_account_cart`
--
ALTER TABLE `clinic_account_cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `clinic_account_order`
--
ALTER TABLE `clinic_account_order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `clinic_account_order_item`
--
ALTER TABLE `clinic_account_order_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `clinic_account_owner_history`
--
ALTER TABLE `clinic_account_owner_history`
  MODIFY `actid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2268;

--
-- AUTO_INCREMENT for table `clinic_account_patient_history`
--
ALTER TABLE `clinic_account_patient_history`
  MODIFY `actid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=301;

--
-- AUTO_INCREMENT for table `clinic_account_payment`
--
ALTER TABLE `clinic_account_payment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clinic_account_product`
--
ALTER TABLE `clinic_account_product`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `clinic_account_staff_history`
--
ALTER TABLE `clinic_account_staff_history`
  MODIFY `actid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=683;

--
-- AUTO_INCREMENT for table `clinic_account_theme_header`
--
ALTER TABLE `clinic_account_theme_header`
  MODIFY `tid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `clinic_account_theme_sidebar`
--
ALTER TABLE `clinic_account_theme_sidebar`
  MODIFY `stid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `clinic_account_type`
--
ALTER TABLE `clinic_account_type`
  MODIFY `account_type` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `clinic_admin`
--
ALTER TABLE `clinic_admin`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `clinic_business_account`
--
ALTER TABLE `clinic_business_account`
  MODIFY `account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `clinic_business_account_announcement`
--
ALTER TABLE `clinic_business_account_announcement`
  MODIFY `announcement_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `clinic_business_account_appointment`
--
ALTER TABLE `clinic_business_account_appointment`
  MODIFY `aid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `clinic_business_account_appointment_follow_up`
--
ALTER TABLE `clinic_business_account_appointment_follow_up`
  MODIFY `fid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `clinic_business_account_inquiry`
--
ALTER TABLE `clinic_business_account_inquiry`
  MODIFY `bid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `clinic_business_account_patient`
--
ALTER TABLE `clinic_business_account_patient`
  MODIFY `client_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `clinic_business_account_paymentintegration`
--
ALTER TABLE `clinic_business_account_paymentintegration`
  MODIFY `pid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `clinic_business_account_subscription`
--
ALTER TABLE `clinic_business_account_subscription`
  MODIFY `subs_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `clinic_business_appointment_feedback`
--
ALTER TABLE `clinic_business_appointment_feedback`
  MODIFY `feedid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `clinic_business_assigned_doctor_appointment`
--
ALTER TABLE `clinic_business_assigned_doctor_appointment`
  MODIFY `docapt` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `clinic_business_main_paymongo_configuration`
--
ALTER TABLE `clinic_business_main_paymongo_configuration`
  MODIFY `config_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `clinic_business_my_appointment_payment`
--
ALTER TABLE `clinic_business_my_appointment_payment`
  MODIFY `payid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `clinic_business_roles`
--
ALTER TABLE `clinic_business_roles`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `clinic_business_service`
--
ALTER TABLE `clinic_business_service`
  MODIFY `bsid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `clinic_business_service_account`
--
ALTER TABLE `clinic_business_service_account`
  MODIFY `sid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `clinic_business_service_ticket`
--
ALTER TABLE `clinic_business_service_ticket`
  MODIFY `ticketid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `clinic_business_service_ticket_response`
--
ALTER TABLE `clinic_business_service_ticket_response`
  MODIFY `response_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `clinic_bussiness_account_users`
--
ALTER TABLE `clinic_bussiness_account_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `clinic_bussiness_account_users_paygrade`
--
ALTER TABLE `clinic_bussiness_account_users_paygrade`
  MODIFY `paygradeid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `clinic_main_faq`
--
ALTER TABLE `clinic_main_faq`
  MODIFY `faq_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `clinic_main_inquiry`
--
ALTER TABLE `clinic_main_inquiry`
  MODIFY `inq_id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
