<?php
require_once('../connect.php');
require_once('../../CLASSES/Leave.php');


$class = new Leave(
                    $_POST['pk'],
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL
                );

$info = array(
        		"pk" => $_POST['pk'],
        		"created_by" => $_POST['created_by'],
                "workdays" => $_POST['workdays'],
                "leave_types_pk" => $_POST['leave_types_pk'],
                "leave_balances" => $_POST['leave_balances'],
                "duration" => $_POST['duration'],
                "category" => $_POST['category']
    		);

$data = $class-> delete($info);

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
    header("HTTP/1.0 200 OK");
}                  

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 