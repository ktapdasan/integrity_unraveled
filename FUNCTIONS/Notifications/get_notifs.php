<?php
require_once('../connect.php');
require_once('../../CLASSES/Notifications.php');

$filters = array(
					'pk' => NULL,
					'notification' => NULL,
					'table_from' => NULL,
					'table_from_pk'=> NULL,
					'read'=>NULL,
					'archived'=>NULL
				);

foreach($_POST as $k=>$v){
	$filters[$k] = $v;
}

$class = new Notifications(
						$filters['pk'], 
						$filters['notification'],
						$filters['table_from'],
						$filters['table_from_pk'],
						$filters['read'],
						$filters['archived']
					);

$data = $class->fetch();

header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>