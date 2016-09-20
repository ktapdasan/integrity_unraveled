<?php
require_once('../connect.php');
require_once('../../CLASSES/Request.php');


$filters = array(
					'pk' => NULL,
					'type' => NULL,
					'recipient' => NULL,
					'archived' => NULL
				);

foreach($_POST as $k=>$v){
	$filters[$k] = $v;
}


$class = new Request(
						$filters['pk'], 
						$filters['type'], 
						$filters['recipient'],
						$filters['archived']
					);




$data = $class->get_request_type($_POST);



header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>