<?php
require_once('../connect.php');
require_once('../../CLASSES/ManualLog.php');


$filters = array(
					'pk' => NULL,
					'employees_pk' => NULL,
					'time_log' => NULL,
					'date_created' => NULL,
					'reason' => NULL,
					'archived' => NULL,
					'type' => NULL
				
				);

foreach($_POST as $k=>$v){
	$filters[$k] = $v;
}

$class = new ManualLog(	
						$filters['pk'], 
						$filters['employees_pk'], 
						$filters['time_log'], 
						$filters['date_created'], 
						$filters['reason'], 
						$filters['archived'],
						$filters['type']
					);

$data = $class-> fetch();

header("HTTP/1.0 404 User Internal Server Error");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));

?>