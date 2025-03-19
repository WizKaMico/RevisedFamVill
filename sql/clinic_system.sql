-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 19, 2025 at 11:16 AM
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_businessPatientBookingCreation` (IN `account_id` INT(11), IN `pid` VARCHAR(50), IN `client_id` INT(10), IN `dob` DATE, IN `age` INT(10), IN `fullname` VARCHAR(100), IN `purpose` VARCHAR(100), IN `purpose_description` TEXT, IN `gender` VARCHAR(50), IN `doa` DATE, IN `fromIns` VARCHAR(50))   BEGIN
INSERT INTO clinic_business_account_appointment (account_id,pid,uid,date_birth,age,fullname,purpose,purpose_description,gender,schedule_date,status,fromIns) VALUES (account_id,pid,client_id,dob,age,fullname,purpose,purpose_description,gender,doa,'BOOKED',fromIns);
SELECT CBAA.* FROM clinic_business_account_appointment CBAA WHERE CBAA.account_id = account_id AND CBAA.pid = pid AND CBAA.uid = client_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_businessPatientBookingView` (IN `uid` INT(10))   BEGIN
SELECT CBAA.*,CBS.service FROM clinic_business_account_appointment CBAA LEFT JOIN clinic_business_service CBS ON CBAA.purpose = CBS.bsid WHERE CBAA.uid = uid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_businessPatientBookingViewUpcoming` (IN `uid` INT(10), IN `dateToday` DATE)   BEGIN
SELECT CBAA.*,CBS.service FROM clinic_business_account_appointment CBAA LEFT JOIN clinic_business_service CBS ON CBAA.purpose = CBS.bsid WHERE CBAA.uid = uid AND CBAA.schedule_date = dateToday;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_createAccountPassword_preliminary` (IN `email` VARCHAR(50), IN `code` INT(50), IN `hashed` VARCHAR(255), IN `password` VARCHAR(50))   BEGIN
  DECLARE isAccountExist INT DEFAULT 0; 
    DECLARE accountStatus VARCHAR(50);

    -- Check if account exists
    SELECT COUNT(*) INTO isAccountExist 
    FROM clinic_business_account CBA
    WHERE CBA.email = email AND CBA.code = code;

    IF isAccountExist > 0 THEN
        -- Fetch account status
        SELECT CBA.status INTO accountStatus 
        FROM clinic_business_account CBA
        WHERE CBA.email = email AND CBA.code = code;

        -- If already subscribed, update only the password
        IF accountStatus = 'SUBSCRIBED' THEN
            UPDATE clinic_business_account CBA
            SET CBA.password = hashed, 
                CBA.unhashed = password 
            WHERE CBA.email = email AND CBA.code = code;
        ELSE
            -- Otherwise, update password and mark as confirmed
            UPDATE clinic_business_account CBA
            SET CBA.password = hashed, 
                CBA.unhashed = password, 
                CBA.status = 'CONFIRMED' 
            WHERE email = email AND code = code;
        END IF;

        -- Return updated account details
        SELECT * FROM clinic_business_account CBA
        WHERE CBA.email = email AND CBA.code = code;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_createAccount_preliminary` (IN `business` VARCHAR(50), IN `email` VARCHAR(50), IN `phone` VARCHAR(50), IN `region` VARCHAR(150), IN `province` VARCHAR(150), IN `city` VARCHAR(150), IN `barangay` VARCHAR(150), IN `street` VARCHAR(150), IN `code` INT(50))   BEGIN
DECLARE accountExist INT DEFAULT 0;
SELECT COUNT(*) INTO accountExist FROM clinic_business_account WHERE email = email OR phone = phone; 
IF accountExist = 0 THEN
  INSERT INTO clinic_business_account (business_name,email,phone,region,province,city,barangay,street,code) VALUES (business,email,phone,region,province,city,barangay,street,code);
  SELECT CBA.* FROM clinic_business_account CBA WHERE CBA.email = email OR CBA.phone = phone;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_faq_view` ()   BEGIN
SELECT CMF.* FROM clinic_main_faq CMF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_inquiry` (IN `fullname` VARCHAR(50), IN `email` VARCHAR(50), IN `subject` VARCHAR(50), IN `message` TEXT)   BEGIN
INSERT INTO clinic_main_inquiry (fullname,email,subject,message) VALUES (fullname,email,subject,message);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_login` (IN `email` VARCHAR(50), IN `password` VARCHAR(255))   BEGIN 
DECLARE isAccountExist INT DEFAULT 0;
SELECT COUNT(*) INTO isAccountExist FROM clinic_business_account CBA WHERE CBA.email = email AND CBA.password = password;
IF isAccountExist > 0 THEN
SELECT CBA.* FROM clinic_business_account CBA WHERE CBA.email = email AND CBA.password = password;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_myAccountBilling` (IN `account_id` INT(11))   BEGIN
SELECT CBAS.* FROM clinic_business_account_subscription CBAS WHERE CBAS.account_id = account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_myAccountBillingIntegration` (IN `account_id` INT(11), IN `public_key` VARCHAR(255), IN `secret_key` VARCHAR(255), IN `status` VARCHAR(50), IN `mode` VARCHAR(50))   BEGIN
INSERT INTO clinic_business_account_paymentintegration (account_id,public_key,secret_key,status,mode) VALUES (account_id,public_key,secret_key,status,mode);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clinic_business_myAccountUsers` (IN `account_id` INT(11))   BEGIN
SELECT CBAU.*,CBR.* FROM clinic_bussiness_account_users CBAU LEFT JOIN clinic_business_roles CBR ON CBAU.role = CBR.role_id WHERE CBAU.account_id = account_id;
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
SELECT CBAU.*,CBA.business_name,CBR.role_name FROM clinic_bussiness_account_users CBAU LEFT JOIN clinic_business_account CBA ON CBAU.account_id = CBA.account_id LEFT JOIN clinic_business_roles CBR ON CBAU.role = CBR.role_id WHERE CBAU.user_id = user_id;
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
(1, 'OCS - PLAN1', 'Lorem ipsum dolor, sit amet consectetur adipisicing elit. Possimus voluptas tempore blanditiis, necessitatibus est accusamus quod numquam quasi laborum iste esse ducimus ratione repudiandae, molestiae autem. Non maiores assumenda minima.', 500.00, '2025-03-15'),
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
(1, 'FamVill', 'familyvilleofficial@gmail.com', '09171439388', 'National Capital Region (NCR)', 'Ncr, Second District', 'Quezon City', 'Santa Lucia', '10 U206 Tarraville Subdivision, Santa Lucia, Novaliches', '21232f297a57a5a743894a0e4a801fc3', 'admin', 'Sole Proprietor', 'uploads/1742302421_1742035607_BSIS4E-GROUP3_ACM_FORMAT.docx', '11111111', 'SUBSCRIBED', 6690, '2025-03-18');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_business_account_announcement`
--

CREATE TABLE `clinic_business_account_announcement` (
  `announcement_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `announcement_title` varchar(50) NOT NULL,
  `announcement_content` text NOT NULL,
  `date_created` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 1, '250318-81881', 1, '2020-06-02', 4, 'Erwin Son', '2 ', 'TEST', 'MALE', '2025-03-18', 'BOOKED', 'WEB', '2025-03-18');

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
(1, 1, 'Erwin Tagulao', 'Erwin012', 'gmfacistol@outlook.com', '09171439388', '21232f297a57a5a743894a0e4a801fc3', 'admin', 'VERIFIED', 859679, '2025-03-18');

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
(1, 1, 'pk_test_9srNwze4WeVdFhYzBdzDTN6W', 'sk_test_w2jX6orfaJGqCeDMXsHqA2SD', 'Active', 'Testing', '2025-03-18');

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
(1, 1, 'grabpay', 'src_RsZmDqiXnMwCvs4zKvWnrZgw', 'familyvilleofficial@gmail.com', '7056', 3, 'PAYED', '2025-03-18');

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
(1, 1, 'Doctor', '2025-03-18'),
(2, 1, 'Assistant Doctor', '2025-03-18');

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
(1, 1, 'CHECKUP', '2025-03-18'),
(2, 1, 'PEDIATRIC', '2025-03-18'),
(3, 1, 'ORTHOPHEDIC', '2025-03-18');

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
(1, 1, 'Erwin Tagulao', 'familyvilleofficial@gmail.com', '09171439388', '21232f297a57a5a743894a0e4a801fc3', 'admin', 1, 'VERIFIED', '2025-03-18');

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
(1, 'Feugiat scelerisque varius morbi enim nunc faucibu', 'Dolor sit amet consectetur adipiscing elit pellentesque habitant morbi. Id\r\n                                        interdum velit laoreet id donec ultrices. Fringilla phasellus faucibus\r\n                                        scelerisque eleifend donec pretium. Est pellentesque elit ullamcorper dignissim.\r\n                                        Mauris ultrices eros in cursus turpis massa tincidunt dui.', '2025-03-16'),
(2, 'Feugiat scelerisque varius morbi enim nunc faucibu', 'Dolor sit amet consectetur adipiscing elit pellentesque habitant morbi. Id\r\n                                        interdum velit laoreet id donec ultrices. Fringilla phasellus faucibus\r\n                                        scelerisque eleifend donec pretium. Est pellentesque elit ullamcorper dignissim.\r\n                                        Mauris ultrices eros in cursus turpis massa tincidunt dui.', '2025-03-16');

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
-- Indexes for table `clinic_business_main_paymongo_configuration`
--
ALTER TABLE `clinic_business_main_paymongo_configuration`
  ADD PRIMARY KEY (`config_id`);

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
-- Indexes for table `clinic_bussiness_account_users`
--
ALTER TABLE `clinic_bussiness_account_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone` (`phone`);

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
-- AUTO_INCREMENT for table `clinic_account_type`
--
ALTER TABLE `clinic_account_type`
  MODIFY `account_type` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `clinic_admin`
--
ALTER TABLE `clinic_admin`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clinic_business_account`
--
ALTER TABLE `clinic_business_account`
  MODIFY `account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `clinic_business_account_announcement`
--
ALTER TABLE `clinic_business_account_announcement`
  MODIFY `announcement_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clinic_business_account_appointment`
--
ALTER TABLE `clinic_business_account_appointment`
  MODIFY `aid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `clinic_business_account_inquiry`
--
ALTER TABLE `clinic_business_account_inquiry`
  MODIFY `bid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clinic_business_account_patient`
--
ALTER TABLE `clinic_business_account_patient`
  MODIFY `client_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `clinic_business_account_paymentintegration`
--
ALTER TABLE `clinic_business_account_paymentintegration`
  MODIFY `pid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `clinic_business_account_subscription`
--
ALTER TABLE `clinic_business_account_subscription`
  MODIFY `subs_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `clinic_business_main_paymongo_configuration`
--
ALTER TABLE `clinic_business_main_paymongo_configuration`
  MODIFY `config_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `clinic_business_roles`
--
ALTER TABLE `clinic_business_roles`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `clinic_business_service`
--
ALTER TABLE `clinic_business_service`
  MODIFY `bsid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `clinic_bussiness_account_users`
--
ALTER TABLE `clinic_bussiness_account_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
