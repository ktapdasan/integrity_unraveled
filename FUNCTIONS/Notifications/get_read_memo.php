<?php
require_once('../connect.php');
require_once('../../CLASSES/Notifications.php');
// print_r($_POST);
$class = new Notifications(
						$_POST['pk'], 
						Null,
						Null,
						Null,
						Null,
						Null
					);
$data = $class->get_read_memo();

header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>