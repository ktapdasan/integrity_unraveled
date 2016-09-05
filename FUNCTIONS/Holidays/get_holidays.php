<?php
require_once('../connect.php');
require_once('../../CLASSES/Holidays.php');


$filters = array(
					'pk' => NULL,
					'name' => NULL,
					'type' => NULL,
					'datex' => NULL,
					'archived' => NULL
				);

foreach($_POST as $k=>$v){
	$filters[$k] = $v;
}


$class = new Holidays(
						$filters['pk'], 
						$filters['name'], 
						$filters['type'],
						$filters['datex'], 
						$filters['archived']
					);




$data = $class->get_holidays($_POST);



header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>