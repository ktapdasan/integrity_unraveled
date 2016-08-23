<?php
require_once('../connect.php');
require_once('../../CLASSES/Leave.php');

$class = new Leave(
						$_POST['pk'], 
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

$data = $class->fetch();

header("HTTP/1.0 404 Internal Error");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>