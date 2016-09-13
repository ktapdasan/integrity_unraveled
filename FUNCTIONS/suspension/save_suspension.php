<?php
require_once('../connect.php');
require_once('../../CLASSES/Suspension.php');

$class = new Suspension(
                                NULL,
                                NULL,
                                NULL,
                                NULL,
                                NULL,
                                NULL
                            );

$extra = array(
                "time_from" => $_POST['time_from'],
                "creator_pk" => $_POST['creator_pk'],
                "time_to" => $_POST['time_to'],
                "date_from" => $_POST['date_from'],
                "date_to" => $_POST['date_to'],
                "remarks" => $_POST['remarks']
            );

$data = $class->save_suspension($extra);

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
    header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              