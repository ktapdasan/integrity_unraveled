<?php
require_once('../connect.php');
require_once('../../CLASSES/Cutoff.php');

$filters = array(
					'pk' => NULL,
					'type' => NULL,
					'archived' => NULL
				);

foreach($_POST as $k=>$v){
	$filters[$k] = $v;
}

$class = new Cutoff(
						$filters['pk'], 
						$filters['type'], 
						$filters['archived']
					);

$data = $class->fetch_types();

header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>