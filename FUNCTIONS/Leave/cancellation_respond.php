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


$extra['created_by'] 		= $_POST['created_by'];
$extra['status'] 			= $_POST['status'];
$extra['remarks'] 			= $_POST['remarks'];

$data = $class->cancellation_respond($extra);


header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?> 