<?php
require_once('../connect.php');
require_once('../../CLASSES/Timesheet.php');

$class = new Timesheet(
						NULL,
						NULL,
						$_POST['cutoff'],
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL
					);

$data = $class->list($_POST);

header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>