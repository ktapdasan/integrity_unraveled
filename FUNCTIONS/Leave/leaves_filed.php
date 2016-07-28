<?php
require_once('../connect.php');
require_once('../../CLASSES/Leave.php');

$filters = array(
					'pk' => NULL,
					'employees_pk' => NULL,
					'leave_types_pk' => NULL,
					'date_started' => NULL,
					'date_ended' => NULL,
					'date_created' => NULL,
					'reason' => NULL,
					'archived' => NULL
				);

foreach($_POST as $k=>$v){
	$filters[$k] = $v;
}

$class = new Leave(
						$filters['pk'], 
						$filters['employees_pk'], 
						$filters['leave_types_pk'], 
						$filters['date_started'], 
						$filters['date_ended'], 
						$filters['date_created'], 
						$filters['reason'], 
						$filters['archived']
					);

$data = $class->leaves_filed();

header("HTTP/1.0 404 Internal Error");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>