<?php
require_once('../connect.php');
require_once('../../CLASSES/Overtime.php');

$class = new Overtime(
							NULL,
							NULL,
							NULL,
							$_POST['employees_pk'],
							NULL,
							NULL
						);

$data = $class->timesheet_overtime($_POST);

header("HTTP/1.0 404 User Internal Server Error");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));

?>