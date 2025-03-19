<?php
session_start();
//Check whether the session variable SESS_MEMBER_ID is present or not
if (!isset($_SESSION['client_id']) || (trim($_SESSION['client_id']) == '')) {
    header("location: ../../CLINIC/?company=".$_SESSION['company']."&view=HOME");
    exit();
}
$client_id=$_SESSION['client_id'];

?>