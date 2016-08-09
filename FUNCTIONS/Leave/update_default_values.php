<?php
require_once('../connect.php');
require_once('../../CLASSES/Default_values.php');

$details = array(
					"regularization" => $_POST['regularization'],
					"staggered" => $_POST['staggered']
				);

$class = new Default_values(	
								$_POST['pk'],
								NULL,
								$details
							);

$data = $class->update($_POST['employees_pk']);


header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?> 