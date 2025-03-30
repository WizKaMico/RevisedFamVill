<?php 

include('../controller/themeController.php'); 

if(isset($_POST['theme']) && isset($_POST['account_id'])) {
    $theme = $_POST["theme"];
    $accountId = $_POST["account_id"];

    try {
        $result = $portCont->checkSideBarTheme($accountId);

        if(!empty($result)) {
            $portCont->updateSideBarTheme($accountId, $theme);
            echo json_encode(["status" => "success", "message" => "Theme updated successfully!"]);
        } else {
            $portCont->createSideBarTheme($accountId, $theme);
            echo json_encode(["status" => "success", "message" => "Theme saved successfully!"]);
        }
    } catch (Exception $e) {
        echo json_encode(["status" => "error", "message" => "Database error: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request!"]);
}
?>
