<?php
require_once('../connect.php');
require_once('../../CLASSES/Default_values.php');

$class = new Default_values(
								NULL,
		                        NULL,
		                        NULL,
		                        NULL
							);

$data = $class->fetch_all();

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));

?>