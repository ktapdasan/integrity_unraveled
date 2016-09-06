<?php
require_once('../connect.php');
require_once('../../CLASSES/Overtime.php');

$class = new Overtime(	
							NULL,
							NULL,
							NULL,
							NULL,
							NULL,
							NULL
					);
$info = array(
        		"overtime_pk" => $_POST['pk'],
        		"created_by" => $_POST['approver_pk'],
        		"status" => $_POST['status'],
        		"remarks" => $_POST['remarks'],
        		"employees_pk"=>$_POST['employees_pk']
    		);


$data = $class->update_overtime($info);


header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>