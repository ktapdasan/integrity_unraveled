<?php
require_once('../connect.php');
require_once('../../CLASSES/Leave.php');

$class = new Leave(	
						NULL,	
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL
					);

$extra['pk'] = $_POST['pk'];
//$extra['reason'] = $_POST['reason'];
$extra['employees_pk'] = $_POST['employees_pk'];
$extra['created_by'] = $_POST['created_by'];
$extra['status'] = $_POST['status'];

$data = $class->update($extra);


header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?> 