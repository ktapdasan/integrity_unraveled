<?php
require_once('../connect.php');
require_once('../../CLASSES/Birthday.php');
// print_r($_POST);
$class = new Birthday_theme(
						Null,
						date('F'),
						Null,
						Null
					);

$data = $class->current_month();

header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>