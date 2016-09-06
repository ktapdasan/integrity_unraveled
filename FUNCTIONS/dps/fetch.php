<?php
require_once('../connect.php');
require_once('../../CLASSES/DailyPassSlip.php');

$class = new DailyPassSlip(
								NULL,
								$_POST['employees_pk'],
								NULL,
		                        NULL,
		                        NULL
							);

$extra = array(
				"date_from" => $_POST['date_from'],
				"date_to" => $_POST['date_to'],
				"status" => $_POST['status'],
				"type" => $_POST['type'],
				"remarks" => $_POST['remarks']

			);

$data = $class->fetch($extra);

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));

?>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 