<?php
require_once('../connect.php');
require_once('../../CLASSES/Department.php');

$filters = array(
					'pk' => NULL,
					'department' => NULL,
					'code' => NULL,
					'archived' => NULL
				);
foreach($_POST as $k=>$v){
	$filters[$k] = $v;
}

$class = new Department(
						$filters['pk'], 
						$filters['department'], 
						$filters['code'], 
						$filters['archived']
					);


$data = $class->get_departments($_POST);

header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));

?>