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
						NULL,
						NULL
					);


$data = $class->cancellation_leave();

header("HTTP/1.0 404 Internal Error");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>