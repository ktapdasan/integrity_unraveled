<?php
require_once('../connect.php');
require_once('../../CLASSES/Birthday.php');
// print_r($_POST);
$filters = array(
					'pk' => NULL,
					'month' => NULL,
					'location' => NULL,
					'archived' => NULL
					
				);

foreach($_POST as $k=>$v){
	$filters[$k] = $v;
}


$class = new Birthday(
						$filters['pk'], 
						$filters['month'], 
						$filters['location'],
						$filters['archived']
					);



$data = $class->get_birthday_theme($_POST);

header("HTTP/1.0 404 Error saving content");
if($data['status']){
    header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>