<?php 



include('../connection/connection.php');

class themeController extends DBController
{

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

    function updateTheme($accountId, $theme)
    {
        $query = "UPDATE clinic_account_theme_header SET themeHeader = ? WHERE account_id = ?";
        
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $theme
            ),
            array(
                "param_type" => "i",
                "param_value" => $accountId
            )
        );
        
        $this->updateDB($query, $params);
    }

    function createTheme($accountId, $theme)
    {
        $query = "INSERT INTO clinic_account_theme_header (account_id, themeHeader) VALUES (?,?)";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $accountId
            ),
            array(
                "param_type" => "s",
                "param_value" => $theme
            )
        );
        
        $this->insertDB($query, $params);
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


    function updateSideBarTheme($accountId, $theme)
    {
        $query = "UPDATE clinic_account_theme_sidebar SET theme = ? WHERE account_id = ?";
        
        $params = array(
            array(
                "param_type" => "s",
                "param_value" => $theme
            ),
            array(
                "param_type" => "i",
                "param_value" => $accountId
            )
        );
        
        $this->updateDB($query, $params);
    }

    function createSideBarTheme($accountId, $theme)
    {
        $query = "INSERT INTO clinic_account_theme_sidebar (account_id, theme) VALUES (?,?)";
        
        $params = array(
            array(
                "param_type" => "i",
                "param_value" => $accountId
            ),
            array(
                "param_type" => "s",
                "param_value" => $theme
            )
        );
        
        $this->insertDB($query, $params);
    }

}

$portCont = new themeController();

?>