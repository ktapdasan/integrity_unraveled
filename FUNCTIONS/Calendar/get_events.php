<?php
require_once('../connect.php');
require_once('../../CLASSES/Calendar.php');

$class = new Calendar(
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

$extra = array('date' => $_POST['date']);
$data = $class->fetch_events($extra);

header("HTTP/1.0 404 No data Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>