<?php
require_once('../connect.php');
require_once('../../CLASSES/ManualLog.php');
$class = new ManualLog(
							NULL,
							$_POST['employees_pk'],
							NULL,
							NULL,
							NULL,
							NULL,
							NULL
						);

$data = $class->employees_manual_logs($_POST);

header("HTTP/1.0 404 User Internal Server Error");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));

?>