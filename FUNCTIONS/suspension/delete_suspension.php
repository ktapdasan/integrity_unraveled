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
                "pk" => $_POST['pk']
            );

$data = $class->delete_suspension($extra);

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
    header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              