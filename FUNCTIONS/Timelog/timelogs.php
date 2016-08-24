<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');
require_once('../../CLASSES/Leave.php');

print_r($_POST);
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

$data = $class->timelogs($filter);
echo "<pre>";
print_r($data['result']);
// header("HTTP/1.0 500 Internal Server Error");
// if($data['status']==true){
// 	header("HTTP/1.0 200 OK");
// }

// header('Content-Type: application/json');
// print(json_encode($data));
?>