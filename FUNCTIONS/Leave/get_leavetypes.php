<?php
require_once('../connect.php');
require_once('../../CLASSES/LeaveTypes.php');

$class = new LeaveTypes(
							NULL, 
							NULL, 
							NULL, 
							NULL, 
							NULL, 
							$_POST['archived']
						);

$data = $class->fetch($_POST['employees_pk']);

header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>