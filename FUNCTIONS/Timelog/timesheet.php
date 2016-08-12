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
							NULL,
							NULL,
							NULL,
							NULL
						);

$filter = array(
	"newdatefrom" => $_POST['newdatefrom'],
	"newdateto" => $_POST['newdateto'],
	"pk" => $_POST['pk']
);

$data = $class->timesheet($filter);

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>