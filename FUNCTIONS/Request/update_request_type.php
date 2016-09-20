<?php
require_once('../connect.php');
require_once('../../CLASSES/Request.php');
// print_r($_POST);
$class = new Request(
				$_POST['pk'],
                $_POST['type'],
                $_POST['recipient'],
                NULL
			);

$data = $class->update_request_type();


header("HTTP/1.0 404 Error saving content");
if($data['status']){
    header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>