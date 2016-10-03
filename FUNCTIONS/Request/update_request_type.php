<?php
require_once('../connect.php');
require_once('../../CLASSES/Request.php');

$class = new Request(
				$_POST['pk'],
                $_POST['type'],
                NULL,
                NULL
			);

$recipients=(array)json_decode($_POST['obj_recipients']);
$pk_arr= array();

foreach ($recipients as $key => $value) {
	array_push($pk_arr, $value->pk);
} 

$data = $class->update_request_type($pk_arr);


header("HTTP/1.0 404 Error saving content");
if($data['status']){
    header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>