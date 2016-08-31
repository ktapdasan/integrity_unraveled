<?php
require_once('../connect.php');
require_once('../../CLASSES/Holidays.php');
// print_r($_POST);
$class = new Holidays(
								NULL,
		                        NULL,
		                        NULL,
		                        NULL,
		                        NULL,
		                        NULL
							);

$data = $class->save_holidays($_POST);

header("HTTP/1.0 404 Error saving content");
if($data['status']){
    header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>