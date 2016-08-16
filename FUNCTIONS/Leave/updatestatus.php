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
						NULL,
						NULL
					);

$extra['employees_pk'] 		= $_POST['employees_pk'];
$extra['created_by'] 		= $_POST['created_by'];
$extra['status'] 			= $_POST['status'];
$extra['category'] 			= $_POST['category'];
$extra['duration'] 			= $_POST['duration'];
$extra['leave_types_pk'] 	= $_POST['leave_types_pk'];
$extra['workdays'] 			= $_POST['workdays'];
$extra['remarks'] 			= $_POST['remarks'];
print_r($_POST);

$data = $class->update($extra);


header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?> 