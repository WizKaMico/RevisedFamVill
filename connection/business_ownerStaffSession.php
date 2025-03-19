<?php
session_start();
//Check whether the session variable SESS_MEMBER_ID is present or not
if (!isset($_SESSION['user_id']) || (trim($_SESSION['user_id']) == '')) {
    header("location: ../../CLINIC/?company=".$_SESSION['company']."&view=HOME");
    exit();
}
$user_id=$_SESSION['user_id'];

?>