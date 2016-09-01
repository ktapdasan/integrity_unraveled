<?php
require_once('../connect.php');
require_once('../../CLASSES/Leave.php');

$class = new Leave(
	
				$_POST['pk'],
				$_POST['employees_pk'],
                NULL,
                NULL,
				NULL,
                NULL,
                NULL,
                NULL,
                NULL
			);

$extra['supervisor_pk'] = $_POST['supervisor_pk'];
$extra['employees_pk'] = $_POST['employees_pk'];
$extra['remarks'] = $_POST['remarks'];


$data = $class-> cancel_leave($extra);

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
       header("HTTP/1.0 200 OK");
}                  

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 