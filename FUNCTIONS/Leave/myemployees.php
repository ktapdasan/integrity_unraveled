<?php
require_once('../connect.php');
require_once('../../CLASSES/Leave.php');


$class = new Leave(
					NULL,
					$_POST['employees_pk'],
					NULL,
					NULL,					
					NULL,
					NULL,
					NULL,
					NULL,
					NULL
				);


$data = $class->myemployees($_POST);



header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>