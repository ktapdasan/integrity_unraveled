<?php
require_once('../connect.php');
require_once('../../CLASSES/Leave.php');

$class = new Leave(
						NULL, 
						$_POST['employees_pk'],
						$_POST['leave_types_pk'],
						$_POST['duration'],
						$_POST['category'],
						$_POST['date_from'],
						$_POST['date_to'],
						NULL,
						NULL,
						NULL
					);

$data = $class->employees_leaves_filed($_POST['supervisor_pk']);

header("HTTP/1.0 404 Internal Error");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>