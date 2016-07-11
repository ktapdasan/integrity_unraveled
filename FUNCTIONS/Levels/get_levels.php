<?php
require_once('../connect.php');
require_once('../../CLASSES/Levels.php');

$filters = array(
					'pk' => NULL,
					'level_title' => NULL,
					'archived' => NULL
				);

foreach($_POST as $k=>$v){
	$filters[$k] = $v;
}

$class = new Levels(
						$filters['pk'], 
						$filters['level_title'],
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