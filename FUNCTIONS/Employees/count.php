<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');

$class = new Employees(
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						'false'
					);

$data = $class->count();

header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>