<?php
require_once('../connect.php');
require_once('../../CLASSES/Titles.php');

$filters = array(
					'pk' => NULL,
					'title' => NULL,
					'created_by' => NULL,
					'date_created' => NULL,
					'archived' => NULL
				);

foreach($_POST as $k=>$v){
	$filters[$k] = $v;
}

$class = new Titles(
						$filters['pk'], 
						$filters['title'], 
						$filters['created_by'], 
						$filters['date_created'],
						$filters['archived']
					);

$data = $class->get_titles();

header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>