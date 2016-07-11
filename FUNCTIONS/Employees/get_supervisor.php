<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');

$filters = array(
					
					'first_name' => NULL,
					
					'last_name' => NULL,
					
					'levels_pk' => NULL
				);

foreach($_POST as $k=>$v){
	$filters[$k] = $v;
}

$class = new Employees(
						
						$filters['first_name'], 
						
						$filters['last_name'], 
						
						$filters['levels_pk']
					);

$data = $class->get_supervisor();

header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>