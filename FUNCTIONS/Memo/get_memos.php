<?php
require_once('../connect.php');
require_once('../../CLASSES/Memo.php');

// print_r($_POST);
$filters = array(
					'pk' => NULL,
					'memo' => NULL,
					'created_by' => NULL,
					'date_created' => NULL,
					'read' => NULL,
					'archived' => NULL
				);

foreach($_POST as $k=>$v){
	$filters[$k] = $v;
}


$class = new Memo(
						$filters['pk'], 
						$filters['memo'], 
						$filters['created_by'],
						$filters['date_created'],
						$filters['read'],
						$filters['archived']
					);




$data = $class->get_memos($_POST);



header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>