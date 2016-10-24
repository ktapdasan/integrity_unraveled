<?php
require_once('../connect.php');
require_once('../../CLASSES/Calendar.php');

$class = new Calendar(
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL
					);

$extra = array(
                "created_by" => $_POST['created_by'],
                "colors" => $_POST['color'],
                "description" => $_POST['description'],
                "location" => $_POST['location'],
                "date_from" => $_POST['date_from'],
                "date_to" => $_POST['date_to'],
                "recipient" => $_POST['recipient'],
                "time_from" => $_POST['time_from'],
                "time_to" => $_POST['time_to']
            );

$data = $class->save_myevents($extra);

header("HTTP/1.0 404 No data Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>