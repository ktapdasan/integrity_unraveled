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

$extra = array(
                "time_from" => $_POST['time_from'],
                "time_to" => $_POST['time_to'],
                "remarks" => $_POST['remarks'],
                "date" => $_POST['date'],
                "type" => $_POST['type']
            );

$data = $class->add_dps($extra);

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
    header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              