<?php
require_once('../connect.php');
require_once('../../CLASSES/Request.php');

$class = new Request(
						$_POST['pk'],
	                    NULL,
	                    NULL,
	                    NULL
					);

$extra['remarks'] = $_POST['remarks'];
$extra['status'] = $_POST['status'];
$extra['created_by'] = $_POST['created_by'];
$extra['employees_pk'] = $_POST['employees_pk'];

$data = $class->update_request($extra);

header("HTTP/1.0 404 Error saving content");
if($data['status']){
    header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>