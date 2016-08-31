<?php
require_once('../connect.php');
require_once('../../CLASSES/Overtime.php');

$class = new Overtime(
						NULL,
						$_POST['time_from'],
						$_POST['time_to'],
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