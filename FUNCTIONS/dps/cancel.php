<?php
require_once('../connect.php');
require_once('../../CLASSES/DailyPassSlip.php');

$class = new DailyPassSlip(
                                NULL,
                                $_POST['employees_pk'],
                                NULL,
                                NULL,
                                NULL
                    );

$info = array(
                "employees_pk" => $_POST['employees_pk'],
                "daily_pass_slip_pk" => $_POST['pk'],
                "status" => $_POST['status'],
                "remarks" => $_POST['remarks']
            );

$data = $class->cancel($info);

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
    header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 