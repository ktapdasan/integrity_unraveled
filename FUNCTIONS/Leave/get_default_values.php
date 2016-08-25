<?php
require_once('../connect.php');
require_once('../../CLASSES/Default_values.php');

$class = new Default_values(	
								NULL,
								$_POST['name'],
								NULL
							);

$data = $class->fetch();


header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?> 