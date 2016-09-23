<?php
require_once('../connect.php');
require_once('../../CLASSES/Default_values.php');

$class = new Default_values(
								NULL,
		                        NULL,
		                        NULL,
		                        NULL
							);

$data = $class->update_work_days($_POST);

header("HTTP/1.0 404 Error saving contact");
if($data['status']){
    header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>