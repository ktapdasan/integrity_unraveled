<?php
require_once('../connect.php');
require_once('../../CLASSES/Request.php');

$class = new Request(
						$_POST['pk'],
	                    $_POST['type'],
	                    NULL,
	                    NULL
					);

$extra['remarks'] = $_POST['remarks'];
$extra['request_type_pk'] = $_POST['request_type_pk'];

$data = $class->add_request($extra);

header("HTTP/1.0 404 Error saving content");
if($data['status']){
    header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>