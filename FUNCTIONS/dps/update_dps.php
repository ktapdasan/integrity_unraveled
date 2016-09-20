<?php
require_once('../connect.php');
require_once('../../CLASSES/DailyPassSlip.php');

$class = new DailyPassSlip(	
							NULL,
							NULL,
							NULL,
							NULL,
							NULL
					);
$info = array(
        		"dps_pk" => $_POST['pk'],
        		"created_by" => $_POST['approver_pk'],
        		"status" => $_POST['status'],
        		"remarks" => $_POST['remarks'],
        		"employees_pk"=>$_POST['employees_pk'],
        		"time_from"=>$_POST['time_from'],
        		"time_to"=>$_POST['time_to'],
        		"leave_pk"=>$_POST['leave_pk'],
                "type"=>$_POST['type']
    		);


$data = $class->update_dps($info);


header("HTTP/1.0 404 User Not Found");
if($data['status']){
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>