<?php
session_start();
//Check whether the session variable SESS_MEMBER_ID is present or not
if (!isset($_SESSION['account_id']) || (trim($_SESSION['account_id']) == '')) {
    header("location: ../../?view=HOME");
    exit();
}
$account_id=$_SESSION['account_id'];

?>