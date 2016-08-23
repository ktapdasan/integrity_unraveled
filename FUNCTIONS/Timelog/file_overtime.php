<?php
require_once('../connect.php');
require_once('../../CLASSES/Overtime.php');

$work_schedule = (array)json_decode($_POST['work_schedule']);

$class = new Overtime(
						NULL,
						$work_schedule['out'],
						$_POST['last_log'],
						$_POST['employees_pk'],
						NULL,
						NULL
					);

$data = array(
				"remarks" => $_POST['remarks']
			);

$data = $class->insert($data);

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>